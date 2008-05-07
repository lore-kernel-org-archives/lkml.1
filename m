Return-Path: <linux-kernel-owner+w=401wt.eu-S1762444AbYEGPVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762444AbYEGPVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 11:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757075AbYEGPV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 11:21:28 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:26137 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169AbYEGPVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 11:21:24 -0400
Date: Wed, 7 May 2008 08:19:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: <JosephChan@via.com.tw>
Cc: <akpm@linux-foundation.org>, <geert@linux-m68k.org>,
       <linux-fbdev-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-fbdev-devel] [PATCH 1/9] viafb: VIA Frame Buffer Device
 Driver
Message-Id: <20080507081948.8dce60dc.randy.dunlap@oracle.com>
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F67724@exchtp03.taipei.via.com.tw>
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F67705@exchtp03.taipei.via.com.tw>
	<C80EF34A3D2E494DBAF9AC29C7AE4EB806F67724@exchtp03.taipei.via.com.tw>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008 18:55:30 +0800 JosephChan@via.com.tw wrote:

> Signed-off-by: Joseph Chan <josephchan@via.com.tw>
> 
> diff -Nur a/Documentation/fb/viafb.txt b/Documentation/fb/viafb.txt
> --- a/Documentation/fb/viafb.txt	1969-12-31 19:00:00.000000000
> -0500
> +++ b/Documentation/fb/viafb.txt	2008-05-06 06:46:26.000000000
> -0400
> @@ -0,0 +1,197 @@
> +
> +        VIA Integration Graphic Chip Console Framebuffer Driver
> +
> +[Platform]
> +-----------------------
> +    The console framebuffer driver is for Graphics chips of

                                             graphics

> +    VIA UniChrome (Pro) Family:
> + 	CLE266, PM800 / CN400,P4M800CE / P4M800Pro / CN700 / VN800, 
> +	CX700 / VX700, P4M890 
> +    VIA Chrome9 Family:
> +	K8M890, CN896 / P4M900, VX800)

                                     ^ drop ")" ?

> +
> +[Driver features]
> +------------------------
> +    Device:CRT, LCD, DVI

       Device: CRT, LCD, DVI

> +
> +    Support Mode:
> +        CRT:   
> +	    640 x480(60, 75, 85, 100, 120 Hz), 720 x480(60 Hz),

Usually NNNxMMM or NNN x MMM (use space consistently).
(multiple times)

> +	    720 x576(60 Hz), 800 x600(60, 75, 85, 100, 120 Hz),
> +	    848 x480(60 Hz), 856 x480(60 Hz), 1024 x512(60 Hz),
> +	    1024 x768(60, 75, 85, 100 Hz), 1152 x864(75 Hz),
> +	    1280 x768(60 Hz), 1280 x960(60 Hz), 1280 x1024(60, 75, 85
> Hz),
> +	    1440 x1050(60 Hz), 1600 x1200(60, 75 Hz), 1280 x720(60 Hz),
> +	    1920 x1080(60 Hz), 1400 x1050(60 Hz), 800 x480(60 Hz)
> +
> +    color depth:8 bpp, 16 bpp, 32 bpp

       color depth: 8 bpp, ...

> +
> +    Support 2 D hardware accelerator for kernel 2.6.xx

               2D or 2-D

> +
> +[Using the viafb module]
> +-- -- --------------------
> +    Start viafb with default settings,

                                settings:

> +        #modprobe viafb
> +
> +    Start viafb with with user options,

                                  options:

> +        #modprobe viafb mode=800x600 via_fb_bpp=16 refresh=60 
> +                  active_dev=CRT+DVI dvi_port = DVP1 mode1 = 1024 x768 
> +                  via_fb_bpp1 = 16 refresh1 = 60 SAMM_ON = 1

I'm pretty sure that you don't want (can't have) spaces around the
"=" signs above.. or does it not matter?  Anyone?

> +
> +    mode:
> +        640 x480(default)

             ...480 (default)  [space before (default)]

> +        720 x480 
> +        800 x600 
> +        1024 x768
> +        ......
> +
> +    via_fb_bpp:
> +        8, 16, 32(default:32)

	add space before "(default:32)"

> +
> +    refresh:
> +        60, 75, 85, 100, 120(default:60)

	add space before...

> +
> +    lcd_dsp_method:
> +        0 : expandsion(default)
> +        1 : centering
> +
> +    lcd_mode:
> +        0 : OPEN LDI(default)
> +        1 : SPWG
> +
> +    lcd_panel_id:
> +        0 : Resolution: 640 x480, Channel: single, Dithering: Enable 
> +        1 : Resolution: 800 x600, Channel: single, Dithering: Enable 
> +        2 : Resolution: 1024 x768, Channel: single, Dithering:Enable
> (default)
> +        3 : Resolution: 1280 x768, Channel: single, Dithering: Enable 
> +        4 : Resolution: 1280 x1024, Channel: dual, Dithering: Enable 
> +        5 : Resolution: 1400 x1050, Channel: dual, Dithering: Enable 
> +        6 : Resolution: 1600 x1200, Channel: dual, Dithering: Enable
> +
> +        8 : Resolution: 800 x480, Channel: single, Dithering: Enable 
> +        9 : Resolution: 1024 x768, Channel: dual, Dithering: Enable 
> +        10: Resolution: 1024 x768, Channel: single, Dithering: Disable 
> +        11: Resolution: 1024 x768, Channel: dual, Dithering: Disable 
> +        12: Resolution: 1280 x768, Channel: single, Dithering: Disable 
> +        13: Resolution: 1280 x1024, Channel: dual, Dithering: Disable 
> +        14: Resolution: 1400 x1050, Channel: dual, Dithering: Disable 
> +        15: Resolution: 1600 x1200, Channel: dual, Dithering: Disable  
> +        16: Resolution: 1366 x768, Channel: single, Dithering: Disable 
> +        17: Resolution: 1024 x600, Channel: single, Dithering: Enable 
> +        18: Resolution: 1280 x768, Channel: dual, Dithering: Enable 
> +        19: Resolution: 1280 x800, Channel: single, Dithering: Enable
> +    
> +    via_fb_accel:
> +        0 : No 2 D Hardware Acceleration(default)
> +        1 : 2 D Hardware Acceleration

2D or 2-D

> +
> +    SAMM_ON:
> +        0 : SAMM_ON disable(default)
> +        1 : SAMM_ON enable

Is SAMM_ON explained somewhere?

> +    mode1:(secondary display device)

	Add space: mode1: (secondary ...

> +        640 x480(default)

	Add space before (default)

> +        720 x480 
> +        800 x600 
> +        1024 x768 
> +        ... ... 
> + 
> +    via_fb_bpp1:(secondary display device) 
> +        8, 16, 32(default:32)

Add space above & below here.

> +    refresh1:(secondary display device) 
> +        60, 75, 85, 100, 120(default:60)
> +
> +    active_dev:
> +        This option is used to specify active devices.(CRT, DVI, LCD,
> CRT + LCD, CRT + DVI,...)
> +        DVI stand for DVI or HDMI, Ex.If you want to enable HDMI, set
> active_dev = DVI

               stands for DVI or HDMI.  E.g., if you want ...

> +        In SAMM case, the previous of active_dev is primary device, and
> the following is secondary device.
> +
> +        For example:
> +        To enable one device, such as DVI only, we should use:
> +        modprobe viafb active_dev = DVI...To enable two devices, such
> as CRT + DVI:

                          active_dev=DVI
	   To enable two device, such as CRT + DVI:

> +        For DuoView case, we can use:
> +        modprobe viafb active_dev = CRT + DVI...OR modprobe viafb
> active_dev = DVI + CRT...

                          active_dev=CRT+DVI...
	   OR
	   modprobe viafb active_dev=DVI=CRT...

> +        For SAMM case:
> +        If CRT is primary and DVI is secondary, we should use:
> +            modprobe viafb active_dev = CRT + DVI SAMM_ON = 1...

No spaces in module parameter strings.

> +        If DVI is primary and CRT is secondary, we should use:
> +            modprobe viafb active_dev = DVI + CRT SAMM_ON = 1...

Ditto.

> +    display_hardware_layout:
> +	      This option is uesed to specify display hardware layout
> for CX700 chip.

                             used

> +        1 : LCD only 
> +        2 : DVI only 
> +        3 : LCD + DVI(default)
> +        4 : LCD1 + LCD2(internal + internal)
> +        16: LCD1 + ExternalLCD2(internal + external)

	Add space before each "(" above.

> +
> +    second_size:
> +        This option is used to set second device memory size(MB) in
> SAMM case.
> +        The minimal size is 16. 
> +
> +    EPIA_DVI:
> +        This option is used to enable DVI on EPIA - M 
> +        0 : No DVI on EPIA - M(default)
> +        1 : DVI on EPIA - M
> +
> +    BusWidth:
> +        When using 24 - Bit Bus Width Digital Interface, this option
> should be set.
> +        12: 12-Bit LVDS or 12-Bit TMDS(default)
> +        24: 24-Bit LVDS or 24-Bit TMDS
> +
> +    LCDDualEdge:
> +        When using Dual Edge Panel, this option should be set.
> +        0 : No Dual Edge Panel(default)
> +        1 : Dual Edge Panel
> +
> +    video_dev:
> +        This option is used to specify video output devices(CRT, DVI,
> LCD) for duoview case.
> +        For example:
> +        To output video on DVI, we should use:
> +            modprobe viafb video_dev = DVI...

No spaces in module parameters...

> +    lcd_port:
> +	      This option is used to specify lcd output port,

                                             LCD output port;

> +        available values are "DVP0" "DVP1" "DFP_HIGHLOW" "DFP_HIGH"
> +	      "DFP_LOW", for external LCD + external DVI on
> CX700(External LCD is on DVP0), 
> +        we should use:
> +	          modprobe viafb lcd_port = DVP0...

No spaces in module parameters.

> +
> +Note:
> +    1. CRT may not display properly for DuoView CRT & DVI display at
> +       the "640x480" PAL mode with DVI overscan enabled.
> +    2. When SAMM is enable, mode and mode1, via_fb_bpp and via_fb_bpp1,
> +       refresh and refresh1 can be different.
> +    3. When console is depend on viafbinfo1, dynamically change
> resolution and bpp,
> +       need call VIAFB specified ioctl interface VIAFB_SET_DEVICE.

I didn't understand that sentence.

> +       Call common ioctl function FBIOPUT_VSCREENINFO will cause sreen
> crush.

                                                                    screen

> +
> +[Configure viafb with "fbset" tool]
> +-----------------------------------
> +    "fbset" is an inbox utility of Linux.
> +    1. Inquire current viafb information, type,
> +           # fbset -i
> +
> +    2. Set various resolutions and refresh rates,
> +           # fbset <resolution-vertical_sync>
> +
> +       example,
> +           # fbset "1024x768-75"
> +       or
> +           # fbset -g 1024 768 1024 768 32
> +      Check the file "/etc/fb.modes" to find display modes available.
> +
> +    3. Set the color depth,
> +           # fbset -depth <value>
> +
> +       example,
> +           # fbset -depth 16
> +
> +[Bootup with viafb]:
> +--------------------
> +    Add the following line to your lilo.conf:
> +        append =  "video=viafb:mode:1024x768,via_fb_bpp:32,refresh:85"


---
~Randy
