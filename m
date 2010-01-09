Return-Path: <linux-kernel-owner+w=401wt.eu-S1751804Ab0AII3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab0AII3j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 03:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448Ab0AII3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 03:29:38 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:55968 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab0AII3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 03:29:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=N6Ca6CJi+LjswqJN6iApSQZWvgd/alcomtUodLCJvGX6ykY48FOPPGU4DQ/zUJclf5
         EttNN/zxqYzJgDaO/n8xTLIphBkGRp0L5tOvx3xgbKE3A2f4Sd2BvTcgkkv3IDTDqbT6
         QxjiZenvLY/i1ylvIsSm5Yv6eNkPbFxBDAKU8=
Date: Sat, 9 Jan 2010 00:29:31 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Steinhauer Juergen <gawith@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: New HID device Philips Remote RC 153_Vista
Message-ID: <20100109082931.GA3289@core.coreip.homeip.net>
References: <4B43BFFE.5090803@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B43BFFE.5090803@gmx.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should go to linux-input so there is bigger chance Jiri notices
it. Probably a simple matter of remapping a few usages and can even be
done from userspace...

On Tue, Jan 05, 2010 at 11:41:02PM +0100, Steinhauer Juergen wrote:
> Hi,
> 
> I have a new IR remote control, packaged with a new Acer PC.
> The device is recognized as 'MCE USB IR Receiver- Spinel plus' and
> is named 'Philips RC 153_Vista'. (http://www.remotecontrol.philips.com/index.cfm?act=dspProduct&productUUID=DED676F4-EDF7-2FB6-CA3E74876E2D89AE&segmentUUID=2599F159-B824-8AE6-14B94D15FC6DDA22&id=1223)
> 
> Most of the buttons are working, but not all. For these buttons not
> even an event is generated.
> 
> Attached the output of hid debug. I've pressed following keys:
> 
> -the "Windows" key
> -the "looks-like-a-TV-with-a-filled-circle-in-it" key
> -the "looks-like-a-TV-with-a-filled-triangle-in-it" key
> -the "square-with-a-CD-in-it" key
> -the "text" key
> -the red key
> -the green key
> -the yellow key
> -the blue key
> 
> I hope this helps to get this remote working.
> 
> Regards.

>  usb 2-3.1: new low speed USB device using ehci_hcd and address 6
>  usb 2-3.1: configuration #1 chosen from 1 choice
>  drivers/hid/usbhid/hid-core.c: HID probe called for ifnum 0
>  drivers/hid/usbhid/hid-core.c: report descriptor (size 427, read 1) =  05 01 09 06 a1 01 85 01 05 07 19 e0 29 e7 15 00 25 01 75 01 95 08 81 02 95 01 75 08 81 01 95 05 75 01 05 08 19 01 29 05 91 02 95 01 75 03 91 01 95 06 75 08 15 00 25 68 05 07 19 00 29 68 81 00 c0 05 01 09 80 a1 01 85 04 05 01 19 81 29 83 15 00 25 01 95 03 75 01 81 06 95 01 75 05 81 01 c0 05 0c 09 01 a1 01 85 02 0a e2 00 0a e9 00 0a ea 00 0a 9c 00 0a 9d 00 0a b5 00 0a b6 00 0a b3 00 0a b4 00 0a b0 00 0a b1 00 0a b7 00 0a b2 00 0a 8d 00 0a 24 02 0a 08 02 0a 09 02 0a 09 02 0a 09 02 0a 09 02 0a 09 02 0a 09 02 0a 09 02 0a 09 02 75 01 95 18 81 06 15 00 25 01 c0 06 bc ff 09 88 a1 01 85 03 0a 42 00 0a 41 00 0a 4f 00 0a 25 00 0a 5a 00 0a 2e 00 0a 28 00 0a 2b 00 0a 4d 00 0a 4c 00 0a 50 00 0a 2d 00 0a 24 00 0a 0d 00 0a 5b 00 0a 5c 00 0a 5d 00 0a 5e 00 0a 3e 00 0a 3f 00 0a 40 00 0a 31 00 0a 4b 00 0a 47 00 0a 49 00 0a 6a 00 0a 2c 00 0a 44 00 0a 81 00 0a 6f 00 0a 48 00 0a 4a 00 0a 3c 00 0a 3d 00 0a 32 00 0a 33 0
> Jan  5 23:18:24 valkyrie kernel: 0 0a 34 00 0a 35 00 0a 36 00 0a 37 00 0a 38 00 0a 39 00 0a 3a 00 0a 80 00 0a 52 00 0a 53 00 0a 54 00 0a 55 00 0a 56 00 0a 58 00 0a 57 00 0a 59 00 0a 51 00 0a 30 00 0a 2f 00 0a 27 00 0a 78 00 0a 78 00 0a 78 00 0a 78 00 0a 78 00 0a 78 00 0a 78 00 0a 78 00 75 01 95 40 81 06 15 00 25 01 c0 06 00 ff 09 00 a1 01 85 05 09 00 19 00 2a ff 00 15 00 26 ff 00 75 08 95 05 81 00 c0
>    INPUT(1)[INPUT
>      Field(0)
>        Usage(8)
>          Keyboard.00e0
>          Keyboard.00e1
>          Keyboard.00e2
>          Keyboard.00e3
>          Keyboard.00e4
>          Keyboard.00e5
>          Keyboard.00e6
>          Keyboard.00e7
>        Logical Minimum(0)
>        Logical Maximum(1)
>        Report Size(1)
>        Report Count(8)
>        Report Offset(0)
>        Flags( Variable Absolute )
>      Field(1)
>        Usage(105)
>          Keyboard.0000
>          Keyboard.0001
>          Keyboard.0002
>          Keyboard.0003
>          Keyboard.0004
>          Keyboard.0005
>          Keyboard.0006
>          Keyboard.0007
>          Keyboard.0008
>          Keyboard.0009
>          Keyboard.000a
>          Keyboard.000b
>          Keyboard.000c
>          Keyboard.000d
>          Keyboard.000e
>          Keyboard.000f
>          Keyboard.0010
>          Keyboard.0011
>          Keyboard.0012
>          Keyboard.0013
>          Keyboard.0014
>          Keyboard.0015
>          Keyboard.0016
>          Keyboard.0017
>          Keyboard.0018
>          Keyboard.0019
>          Keyboard.001a
>          Keyboard.001b
>          Keyboard.001c
>          Keyboard.001d
>          Keyboard.001e
>          Keyboard.001f
>          Keyboard.0020
>          Keyboard.0021
>          Keyboard.0022
>          Keyboard.0023
>          Keyboard.0024
>          Keyboard.0025
>          Keyboard.0026
>          Keyboard.0027
>          Keyboard.0028
>          Keyboard.0029
>          Keyboard.002a
>          Keyboard.002b
>          Keyboard.002c
>          Keyboard.002d
>          Keyboard.002e
>          Keyboard.002f
>          Keyboard.0030
>          Keyboard.0031
>          Keyboard.0032
>          Keyboard.0033
>          Keyboard.0034
>          Keyboard.0035
>          Keyboard.0036
>          Keyboard.0037
>          Keyboard.0038
>          Keyboard.0039
>          Keyboard.003a
>          Keyboard.003b
>          Keyboard.003c
>          Keyboard.003d
>          Keyboard.003e
>          Keyboard.003f
>          Keyboard.0040
>          Keyboard.0041
>          Keyboard.0042
>          Keyboard.0043
>          Keyboard.0044
>          Keyboard.0045
>          Keyboard.0046
>          Keyboard.0047
>          Keyboard.0048
>          Keyboard.0049
>          Keyboard.004a
>          Keyboard.004b
>          Keyboard.004c
>          Keyboard.004d
>          Keyboard.004e
>          Keyboard.004f
>          Keyboard.0050
>          Keyboard.0051
>          Keyboard.0052
>          Keyboard.0053
>          Keyboard.0054
>          Keyboard.0055
>          Keyboard.0056
>          Keyboard.0057
>          Keyboard.0058
>          Keyboard.0059
>          Keyboard.005a
>          Keyboard.005b
>          Keyboard.005c
>          Keyboard.005d
>          Keyboard.005e
>          Keyboard.005f
>          Keyboard.0060
>          Keyboard.0061
>          Keyboard.0062
>          Keyboard.0063
>          Keyboard.0064
>          Keyboard.0065
>          Keyboard.0066
>          Keyboard.0067
>          Keyboard.0068
>        Logical Minimum(0)
>        Logical Maximum(104)
>        Report Size(8)
>        Report Count(6)
>        Report Offset(16)
>        Flags( Array Absolute )
>    INPUT(4)[INPUT
>      Field(0)
>        Usage(3)
>          GenericDesktop.SystemPowerDown
>          GenericDesktop.SystemSleep
>          GenericDesktop.SystemWakeUp
>        Logical Minimum(0)
>        Logical Maximum(1)
>        Report Size(1)
>        Report Count(3)
>        Report Offset(0)
>        Flags( Variable Relative )
>    INPUT(2)[INPUT
>      Field(0)
>        Usage(24)
>          Consumer.00e2
>          Consumer.00e9
>          Consumer.00ea
>          Consumer.009c
>          Consumer.009d
>          Consumer.00b5
>          Consumer.00b6
>          Consumer.00b3
>          Consumer.00b4
>          Consumer.00b0
>          Consumer.00b1
>          Consumer.00b7
>          Consumer.00b2
>          Consumer.008d
>          Consumer.0224
>          Consumer.0208
>          Consumer.0209
>          Consumer.0209
>          Consumer.0209
>          Consumer.0209
>          Consumer.0209
>          Consumer.0209
>          Consumer.0209
>          Consumer.0209
>        Logical Minimum(0)
>        Logical Maximum(1)
>        Report Size(1)
>        Report Count(24)
>        Report Offset(0)
>        Flags( Variable Relative )
>    INPUT(3)[INPUT
>      Field(0)
>        Usage(64)
>          ffbc.0042
>          ffbc.0041
>          ffbc.004f
>          ffbc.0025
>          ffbc.005a
>          ffbc.002e
>          ffbc.0028
>          ffbc.002b
>          ffbc.004d
>          ffbc.004c
>          ffbc.0050
>          ffbc.002d
>          ffbc.0024
>          ffbc.000d
>          ffbc.005b
>          ffbc.005c
>          ffbc.005d
>          ffbc.005e
>          ffbc.003e
>          ffbc.003f
>          ffbc.0040
>          ffbc.0031
>          ffbc.004b
>          ffbc.0047
>          ffbc.0049
>          ffbc.006a
>          ffbc.002c
>          ffbc.0044
>          ffbc.0081
>          ffbc.006f
>          ffbc.0048
>          ffbc.004a
>          ffbc.003c
>          ffbc.003d
>          ffbc.0032
>          ffbc.0033
>          ffbc.0034
>          ffbc.0035
>          ffbc.0036
>          ffbc.0037
>          ffbc.0038
>          ffbc.0039
>          ffbc.003a
>          ffbc.0080
>          ffbc.0052
>          ffbc.0053
>          ffbc.0054
>          ffbc.0055
>          ffbc.0056
>          ffbc.0058
>          ffbc.0057
>          ffbc.0059
>          ffbc.0051
>          ffbc.0030
>          ffbc.002f
>          ffbc.0027
>          ffbc.0078
>          ffbc.0078
>          ffbc.0078
>          ffbc.0078
>          ffbc.0078
>          ffbc.0078
>          ffbc.0078
>          ffbc.0078
>        Logical Minimum(0)
>        Logical Maximum(1)
>        Report Size(1)
>        Report Count(64)
>        Report Offset(0)
>        Flags( Variable Relative )
>    INPUT(5)[INPUT
>      Field(0)
>        Usage(257)
>          ff00.0000
>          ff00.0000
>          ff00.0001
>          ff00.0002
>          ff00.0003
>          ff00.0004
>          ff00.0005
>          ff00.0006
>          ff00.0007
>          ff00.0008
>          ff00.0009
>          ff00.000a
>          ff00.000b
>          ff00.000c
>          ff00.000d
>          ff00.000e
>          ff00.000f
>          ff00.0010
>          ff00.0011
>          ff00.0012
>          ff00.0013
>          ff00.0014
>          ff00.0015
>          ff00.0016
>          ff00.0017
>          ff00.0018
>          ff00.0019
>          ff00.001a
>          ff00.001b
>          ff00.001c
>          ff00.001d
>          ff00.001e
>          ff00.001f
>          ff00.0020
>          ff00.0021
>          ff00.0022
>          ff00.0023
>          ff00.0024
>          ff00.0025
>          ff00.0026
>          ff00.0027
>          ff00.0028
>          ff00.0029
>          ff00.002a
>          ff00.002b
>          ff00.002c
>          ff00.002d
>          ff00.002e
>          ff00.002f
>          ff00.0030
>          ff00.0031
>          ff00.0032
>          ff00.0033
>          ff00.0034
>          ff00.0035
>          ff00.0036
>          ff00.0037
>          ff00.0038
>          ff00.0039
>          ff00.003a
>          ff00.003b
>          ff00.003c
>          ff00.003d
>          ff00.003e
>          ff00.003f
>          ff00.0040
>          ff00.0041
>          ff00.0042
>          ff00.0043
>          ff00.0044
>          ff00.0045
>          ff00.0046
>          ff00.0047
>          ff00.0048
>          ff00.0049
>          ff00.004a
>          ff00.004b
>          ff00.004c
>          ff00.004d
>          ff00.004e
>          ff00.004f
>          ff00.0050
>          ff00.0051
>          ff00.0052
>          ff00.0053
>          ff00.0054
>          ff00.0055
>          ff00.0056
>          ff00.0057
>          ff00.0058
>          ff00.0059
>          ff00.005a
>          ff00.005b
>          ff00.005c
>          ff00.005d
>          ff00.005e
>          ff00.005f
>          ff00.0060
>          ff00.0061
>          ff00.0062
>          ff00.0063
>          ff00.0064
>          ff00.0065
>          ff00.0066
>          ff00.0067
>          ff00.0068
>          ff00.0069
>          ff00.006a
>          ff00.006b
>          ff00.006c
>          ff00.006d
>          ff00.006e
>          ff00.006f
>          ff00.0070
>          ff00.0071
>          ff00.0072
>          ff00.0073
>          ff00.0074
>          ff00.0075
>          ff00.0076
>          ff00.0077
>          ff00.0078
>          ff00.0079
>          ff00.007a
>          ff00.007b
>          ff00.007c
>          ff00.007d
>          ff00.007e
>          ff00.007f
>          ff00.0080
>          ff00.0081
>          ff00.0082
>          ff00.0083
>          ff00.0084
>          ff00.0085
>          ff00.0086
>          ff00.0087
>          ff00.0088
>          ff00.0089
>          ff00.008a
>          ff00.008b
>          ff00.008c
>          ff00.008d
>          ff00.008e
>          ff00.008f
>          ff00.0090
>          ff00.0091
>          ff00.0092
>          ff00.0093
>          ff00.0094
>          ff00.0095
>          ff00.0096
>          ff00.0097
>          ff00.0098
>          ff00.0099
>          ff00.009a
>          ff00.009b
>          ff00.009c
>          ff00.009d
>          ff00.009e
>          ff00.009f
>          ff00.00a0
>          ff00.00a1
>          ff00.00a2
>          ff00.00a3
>          ff00.00a4
>          ff00.00a5
>          ff00.00a6
>          ff00.00a7
>          ff00.00a8
>          ff00.00a9
>          ff00.00aa
>          ff00.00ab
>          ff00.00ac
>          ff00.00ad
>          ff00.00ae
>          ff00.00af
>          ff00.00b0
>          ff00.00b1
>          ff00.00b2
>          ff00.00b3
>          ff00.00b4
>          ff00.00b5
>          ff00.00b6
>          ff00.00b7
>          ff00.00b8
>          ff00.00b9
>          ff00.00ba
>          ff00.00bb
>          ff00.00bc
>          ff00.00bd
>          ff00.00be
>          ff00.00bf
>          ff00.00c0
>          ff00.00c1
>          ff00.00c2
>          ff00.00c3
>          ff00.00c4
>          ff00.00c5
>          ff00.00c6
>          ff00.00c7
>          ff00.00c8
>          ff00.00c9
>          ff00.00ca
>          ff00.00cb
>          ff00.00cc
>          ff00.00cd
>          ff00.00ce
>          ff00.00cf
>          ff00.00d0
>          ff00.00d1
>          ff00.00d2
>          ff00.00d3
>          ff00.00d4
>          ff00.00d5
>          ff00.00d6
>          ff00.00d7
>          ff00.00d8
>          ff00.00d9
>          ff00.00da
>          ff00.00db
>          ff00.00dc
>          ff00.00dd
>          ff00.00de
>          ff00.00df
>          ff00.00e0
>          ff00.00e1
>          ff00.00e2
>          ff00.00e3
>          ff00.00e4
>          ff00.00e5
>          ff00.00e6
>          ff00.00e7
>          ff00.00e8
>          ff00.00e9
>          ff00.00ea
>          ff00.00eb
>          ff00.00ec
>          ff00.00ed
>          ff00.00ee
>          ff00.00ef
>          ff00.00f0
>          ff00.00f1
>          ff00.00f2
>          ff00.00f3
>          ff00.00f4
>          ff00.00f5
>          ff00.00f6
>          ff00.00f7
>          ff00.00f8
>          ff00.00f9
>          ff00.00fa
>          ff00.00fb
>          ff00.00fc
>          ff00.00fd
>          ff00.00fe
>          ff00.00ff
>        Logical Minimum(0)
>        Logical Maximum(255)
>        Report Size(8)
>        Report Count(5)
>        Report Offset(0)
>        Flags( Array Absolute )
>    OUTPUT(1)[OUTPUT
>      Field(0)
>        Usage(5)
>          LED.NumLock
>          LED.CapsLock
>          LED.ScrollLock
>          LED.Compose
>          LED.Kana
>        Logical Minimum(0)
>        Logical Maximum(1)
>        Report Size(1)
>        Report Count(5)
>        Report Offset(0)
>        Flags( Variable Absolute )
>  hid-debug: input LED.NumLock = 0
>  drivers/hid/usbhid/hid-core.c: submitting ctrl urb: Set_Report wValue=0x0201 wIndex=0x0000 wLength=2
>  drivers/hid/hid-input.c: Mapping: Keyboard.00e0 ---> Key.LeftControl
>  drivers/hid/hid-input.c: Mapping: Keyboard.00e1 ---> Key.LeftShift
>  drivers/hid/hid-input.c: Mapping: Keyboard.00e2 ---> Key.LeftAlt
>  drivers/hid/hid-input.c: Mapping: Keyboard.00e3 ---> Key.LeftMeta
>  drivers/hid/hid-input.c: Mapping: Keyboard.00e4 ---> Key.RightCtrl
>  drivers/hid/hid-input.c: Mapping: Keyboard.00e5 ---> Key.RightShift
>  drivers/hid/hid-input.c: Mapping: Keyboard.00e6 ---> Key.RightAlt
>  drivers/hid/hid-input.c: Mapping: Keyboard.00e7 ---> Key.RightMeta
>  drivers/hid/hid-input.c: Mapping: Keyboard.0000 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: Keyboard.0001 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: Keyboard.0002 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: Keyboard.0003 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: Keyboard.0004 ---> Key.A
>  drivers/hid/hid-input.c: Mapping: Keyboard.0005 ---> Key.B
>  drivers/hid/hid-input.c: Mapping: Keyboard.0006 ---> Key.C
>  drivers/hid/hid-input.c: Mapping: Keyboard.0007 ---> Key.D
>  drivers/hid/hid-input.c: Mapping: Keyboard.0008 ---> Key.E
>  drivers/hid/hid-input.c: Mapping: Keyboard.0009 ---> Key.F
>  drivers/hid/hid-input.c: Mapping: Keyboard.000a ---> Key.G
>  drivers/hid/hid-input.c: Mapping: Keyboard.000b ---> Key.H
>  drivers/hid/hid-input.c: Mapping: Keyboard.000c ---> Key.I
>  drivers/hid/hid-input.c: Mapping: Keyboard.000d ---> Key.J
>  drivers/hid/hid-input.c: Mapping: Keyboard.000e ---> Key.K
>  drivers/hid/hid-input.c: Mapping: Keyboard.000f ---> Key.L
>  drivers/hid/hid-input.c: Mapping: Keyboard.0010 ---> Key.M
>  drivers/hid/hid-input.c: Mapping: Keyboard.0011 ---> Key.N
>  drivers/hid/hid-input.c: Mapping: Keyboard.0012 ---> Key.O
>  drivers/hid/hid-input.c: Mapping: Keyboard.0013 ---> Key.P
>  drivers/hid/hid-input.c: Mapping: Keyboard.0014 ---> Key.Q
>  drivers/hid/hid-input.c: Mapping: Keyboard.0015 ---> Key.R
>  drivers/hid/hid-input.c: Mapping: Keyboard.0016 ---> Key.S
>  drivers/hid/hid-input.c: Mapping: Keyboard.0017 ---> Key.T
>  drivers/hid/hid-input.c: Mapping: Keyboard.0018 ---> Key.U
>  drivers/hid/hid-input.c: Mapping: Keyboard.0019 ---> Key.V
>  drivers/hid/hid-input.c: Mapping: Keyboard.001a ---> Key.W
>  drivers/hid/hid-input.c: Mapping: Keyboard.001b ---> Key.X
>  drivers/hid/hid-input.c: Mapping: Keyboard.001c ---> Key.Y
>  drivers/hid/hid-input.c: Mapping: Keyboard.001d ---> Key.Z
>  drivers/hid/hid-input.c: Mapping: Keyboard.001e ---> Key.1
>  drivers/hid/hid-input.c: Mapping: Keyboard.001f ---> Key.2
>  drivers/hid/hid-input.c: Mapping: Keyboard.0020 ---> Key.3
>  drivers/hid/hid-input.c: Mapping: Keyboard.0021 ---> Key.4
>  drivers/hid/hid-input.c: Mapping: Keyboard.0022 ---> Key.5
>  drivers/hid/hid-input.c: Mapping: Keyboard.0023 ---> Key.6
>  drivers/hid/hid-input.c: Mapping: Keyboard.0024 ---> Key.7
>  drivers/hid/hid-input.c: Mapping: Keyboard.0025 ---> Key.8
>  drivers/hid/hid-input.c: Mapping: Keyboard.0026 ---> Key.9
>  drivers/hid/hid-input.c: Mapping: Keyboard.0027 ---> Key.0
>  drivers/hid/hid-input.c: Mapping: Keyboard.0028 ---> Key.Enter
>  drivers/hid/hid-input.c: Mapping: Keyboard.0029 ---> Key.Esc
>  drivers/hid/hid-input.c: Mapping: Keyboard.002a ---> Key.Backspace
>  drivers/hid/hid-input.c: Mapping: Keyboard.002b ---> Key.Tab
>  drivers/hid/hid-input.c: Mapping: Keyboard.002c ---> Key.Space
>  drivers/hid/hid-input.c: Mapping: Keyboard.002d ---> Key.Minus
>  drivers/hid/hid-input.c: Mapping: Keyboard.002e ---> Key.Equal
>  drivers/hid/hid-input.c: Mapping: Keyboard.002f ---> Key.LeftBrace
>  drivers/hid/hid-input.c: Mapping: Keyboard.0030 ---> Key.RightBrace
>  drivers/hid/hid-input.c: Mapping: Keyboard.0031 ---> Key.BackSlash
>  drivers/hid/hid-input.c: Mapping: Keyboard.0032 ---> Key.BackSlash
>  drivers/hid/hid-input.c: Mapping: Keyboard.0033 ---> Key.Semicolon
>  drivers/hid/hid-input.c: Mapping: Keyboard.0034 ---> Key.Apostrophe
>  drivers/hid/hid-input.c: Mapping: Keyboard.0035 ---> Key.Grave
>  drivers/hid/hid-input.c: Mapping: Keyboard.0036 ---> Key.Comma
>  drivers/hid/hid-input.c: Mapping: Keyboard.0037 ---> Key.Dot
>  drivers/hid/hid-input.c: Mapping: Keyboard.0038 ---> Key.Slash
>  drivers/hid/hid-input.c: Mapping: Keyboard.0039 ---> Key.CapsLock
>  drivers/hid/hid-input.c: Mapping: Keyboard.003a ---> Key.F1
>  drivers/hid/hid-input.c: Mapping: Keyboard.003b ---> Key.F2
>  drivers/hid/hid-input.c: Mapping: Keyboard.003c ---> Key.F3
>  drivers/hid/hid-input.c: Mapping: Keyboard.003d ---> Key.F4
>  drivers/hid/hid-input.c: Mapping: Keyboard.003e ---> Key.F5
>  drivers/hid/hid-input.c: Mapping: Keyboard.003f ---> Key.F6
>  drivers/hid/hid-input.c: Mapping: Keyboard.0040 ---> Key.F7
>  drivers/hid/hid-input.c: Mapping: Keyboard.0041 ---> Key.F8
>  drivers/hid/hid-input.c: Mapping: Keyboard.0042 ---> Key.F9
>  drivers/hid/hid-input.c: Mapping: Keyboard.0043 ---> Key.F10
>  drivers/hid/hid-input.c: Mapping: Keyboard.0044 ---> Key.F11
>  drivers/hid/hid-input.c: Mapping: Keyboard.0045 ---> Key.F12
>  drivers/hid/hid-input.c: Mapping: Keyboard.0046 ---> Key.SysRq
>  drivers/hid/hid-input.c: Mapping: Keyboard.0047 ---> Key.ScrollLock
>  drivers/hid/hid-input.c: Mapping: Keyboard.0048 ---> Key.Pause
>  drivers/hid/hid-input.c: Mapping: Keyboard.0049 ---> Key.Insert
>  drivers/hid/hid-input.c: Mapping: Keyboard.004a ---> Key.Home
>  drivers/hid/hid-input.c: Mapping: Keyboard.004b ---> Key.PageUp
>  drivers/hid/hid-input.c: Mapping: Keyboard.004c ---> Key.Delete
>  drivers/hid/hid-input.c: Mapping: Keyboard.004d ---> Key.End
>  drivers/hid/hid-input.c: Mapping: Keyboard.004e ---> Key.PageDown
>  drivers/hid/hid-input.c: Mapping: Keyboard.004f ---> Key.Right
>  drivers/hid/hid-input.c: Mapping: Keyboard.0050 ---> Key.Left
>  drivers/hid/hid-input.c: Mapping: Keyboard.0051 ---> Key.Down
>  drivers/hid/hid-input.c: Mapping: Keyboard.0052 ---> Key.Up
>  drivers/hid/hid-input.c: Mapping: Keyboard.0053 ---> Key.NumLock
>  drivers/hid/hid-input.c: Mapping: Keyboard.0054 ---> Key.KPSlash
>  drivers/hid/hid-input.c: Mapping: Keyboard.0055 ---> Key.KPAsterisk
>  drivers/hid/hid-input.c: Mapping: Keyboard.0056 ---> Key.KPMinus
>  drivers/hid/hid-input.c: Mapping: Keyboard.0057 ---> Key.KPPlus
>  drivers/hid/hid-input.c: Mapping: Keyboard.0058 ---> Key.KPEnter
>  drivers/hid/hid-input.c: Mapping: Keyboard.0059 ---> Key.KP1
>  drivers/hid/hid-input.c: Mapping: Keyboard.005a ---> Key.KP2
>  drivers/hid/hid-input.c: Mapping: Keyboard.005b ---> Key.KP3
>  drivers/hid/hid-input.c: Mapping: Keyboard.005c ---> Key.KP4
>  drivers/hid/hid-input.c: Mapping: Keyboard.005d ---> Key.KP5
>  drivers/hid/hid-input.c: Mapping: Keyboard.005e ---> Key.KP6
>  drivers/hid/hid-input.c: Mapping: Keyboard.005f ---> Key.KP7
>  drivers/hid/hid-input.c: Mapping: Keyboard.0060 ---> Key.KP8
>  drivers/hid/hid-input.c: Mapping: Keyboard.0061 ---> Key.KP9
>  drivers/hid/hid-input.c: Mapping: Keyboard.0062 ---> Key.KP0
>  drivers/hid/hid-input.c: Mapping: Keyboard.0063 ---> Key.KPDot
>  drivers/hid/hid-input.c: Mapping: Keyboard.0064 ---> Key.102nd
>  drivers/hid/hid-input.c: Mapping: Keyboard.0065 ---> Key.Compose
>  drivers/hid/hid-input.c: Mapping: Keyboard.0066 ---> Key.Power
>  drivers/hid/hid-input.c: Mapping: Keyboard.0067 ---> Key.KPEqual
>  drivers/hid/hid-input.c: Mapping: Keyboard.0068 ---> Key.F13
>  drivers/hid/hid-input.c: Mapping: GenericDesktop.SystemPowerDown ---> Key.Power
>  drivers/hid/hid-input.c: Mapping: GenericDesktop.SystemSleep ---> Key.Sleep
>  drivers/hid/hid-input.c: Mapping: GenericDesktop.SystemWakeUp ---> Key.WakeUp
>  drivers/hid/hid-input.c: Mapping: Consumer.00e2 ---> Key.Mute
>  drivers/hid/hid-input.c: Mapping: Consumer.00e9 ---> Key.VolumeUp
>  drivers/hid/hid-input.c: Mapping: Consumer.00ea ---> Key.VolumeDown
>  drivers/hid/hid-input.c: Mapping: Consumer.009c ---> Key.ChannelUp
>  drivers/hid/hid-input.c: Mapping: Consumer.009d ---> Key.ChannelDown
>  drivers/hid/hid-input.c: Mapping: Consumer.00b5 ---> Key.NextSong
>  drivers/hid/hid-input.c: Mapping: Consumer.00b6 ---> Key.PreviousSong
>  drivers/hid/hid-input.c: Mapping: Consumer.00b3 ---> Key.FastForward
>  drivers/hid/hid-input.c: Mapping: Consumer.00b4 ---> Key.Rewind
>  drivers/hid/hid-input.c: Mapping: Consumer.00b0 ---> Key.Play
>  drivers/hid/hid-input.c: Mapping: Consumer.00b1 ---> Key.Pause
>  drivers/hid/hid-input.c: Mapping: Consumer.00b7 ---> Key.StopCD
>  drivers/hid/hid-input.c: Mapping: Consumer.00b2 ---> Key.Record
>  drivers/hid/hid-input.c: Mapping: Consumer.008d ---> Key.Program
>  drivers/hid/hid-input.c: Mapping: Consumer.0224 ---> Key.Back
>  drivers/hid/hid-input.c: Mapping: Consumer.0208 ---> Key.Print
>  drivers/hid/hid-input.c: Mapping: Consumer.0209 ---> Key.Props
>  drivers/hid/hid-input.c: Mapping: Consumer.0209 ---> Key.Props
>  drivers/hid/hid-input.c: Mapping: Consumer.0209 ---> Key.Props
>  drivers/hid/hid-input.c: Mapping: Consumer.0209 ---> Key.Props
>  drivers/hid/hid-input.c: Mapping: Consumer.0209 ---> Key.Props
>  drivers/hid/hid-input.c: Mapping: Consumer.0209 ---> Key.Props
>  drivers/hid/hid-input.c: Mapping: Consumer.0209 ---> Key.Props
>  drivers/hid/hid-input.c: Mapping: Consumer.0209 ---> Key.Props
>  drivers/hid/hid-input.c: Mapping: ffbc.0042 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0041 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.004f ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0025 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.005a ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.002e ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0028 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.002b ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.004d ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.004c ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0050 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.002d ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0024 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.000d ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.005b ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.005c ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.005d ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.005e ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.003e ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.003f ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0040 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0031 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.004b ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0047 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0049 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.006a ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.002c ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0044 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0081 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.006f ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0048 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.004a ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.003c ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.003d ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0032 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0033 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0034 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0035 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0036 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0037 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0038 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0039 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.003a ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0080 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0052 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0053 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0054 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0055 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0056 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0058 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0057 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0059 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0051 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0030 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.002f ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0027 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0078 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0078 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0078 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0078 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0078 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0078 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0078 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ffbc.0078 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0000 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0000 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0001 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0002 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0003 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0004 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0005 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0006 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0007 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0008 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0009 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.000a ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.000b ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.000c ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.000d ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.000e ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.000f ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0010 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0011 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0012 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0013 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0014 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0015 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0016 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0017 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0018 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0019 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.001a ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.001b ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.001c ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.001d ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.001e ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.001f ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0020 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0021 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0022 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0023 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0024 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0025 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0026 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0027 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0028 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0029 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.002a ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.002b ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.002c ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.002d ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.002e ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.002f ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0030 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0031 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0032 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0033 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0034 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0035 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0036 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0037 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0038 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0039 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.003a ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.003b ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.003c ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.003d ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.003e ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.003f ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0040 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0041 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0042 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0043 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0044 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0045 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0046 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0047 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0048 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0049 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.004a ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.004b ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.004c ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.004d ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.004e ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.004f ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0050 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0051 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0052 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0053 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0054 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0055 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0056 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0057 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0058 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0059 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.005a ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.005b ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.005c ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.005d ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.005e ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.005f ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0060 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0061 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0062 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0063 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0064 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0065 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0066 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0067 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0068 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0069 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.006a ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.006b ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.006c ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.006d ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.006e ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.006f ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0070 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0071 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0072 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0073 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0074 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0075 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0076 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0077 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0078 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0079 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.007a ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.007b ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.007c ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.007d ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.007e ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.007f ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0080 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0081 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0082 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0083 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0084 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0085 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0086 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0087 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0088 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0089 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.008a ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.008b ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.008c ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.008d ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.008e ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.008f ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0090 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0091 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0092 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0093 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0094 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0095 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0096 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0097 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0098 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.0099 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.009a ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.009b ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.009c ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.009d ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.009e ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.009f ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00a0 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00a1 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00a2 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00a3 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00a4 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00a5 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00a6 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00a7 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00a8 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00a9 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00aa ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00ab ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00ac ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00ad ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00ae ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00af ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00b0 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00b1 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00b2 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00b3 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00b4 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00b5 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00b6 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00b7 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00b8 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00b9 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00ba ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00bb ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00bc ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00bd ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00be ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00bf ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00c0 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00c1 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00c2 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00c3 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00c4 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00c5 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00c6 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00c7 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00c8 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00c9 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00ca ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00cb ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00cc ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00cd ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00ce ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00cf ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00d0 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00d1 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00d2 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00d3 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00d4 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00d5 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00d6 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00d7 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00d8 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00d9 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00da ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00db ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00dc ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00dd ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00de ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00df ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00e0 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00e1 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00e2 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00e3 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00e4 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00e5 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00e6 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00e7 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00e8 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00e9 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00ea ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00eb ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00ec ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00ed ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00ee ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00ef ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00f0 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00f1 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00f2 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00f3 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00f4 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00f5 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00f6 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00f7 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00f8 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00f9 ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00fa ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00fb ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00fc ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00fd ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00fe ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: ff00.00ff ---> IGNORED
>  drivers/hid/hid-input.c: Mapping: LED.NumLock ---> LED.NumLock
>  drivers/hid/hid-input.c: Mapping: LED.CapsLock ---> LED.CapsLock
>  drivers/hid/hid-input.c: Mapping: LED.ScrollLock ---> LED.ScrollLock
>  drivers/hid/hid-input.c: Mapping: LED.Compose ---> LED.Compose
>  drivers/hid/hid-input.c: Mapping: LED.Kana ---> LED.Kana
>  input: PHILIPS MCE USB IR Receiver- Spinel plus as /devices/pci0000:00/0000:00:1d.7/usb2/2-3/2-3.1/2-3.1:1.0/input/input7
>  generic-usb 0003:0471:0613.0004: input,hiddev96,hidraw2: USB HID v1.00 Keyboard [PHILIPS MCE USB IR Receiver- Spinel plus
>  drivers/hid/hid-core.c: report (size 9) (numbered)
>  drivers/hid/hid-core.c: report 3 (size 9) =  03 00 20 00 00 00 00 00 00
>  hid-debug: input ffbc.0042 = 0
>  hid-debug: input ffbc.0041 = 0
>  hid-debug: input ffbc.004f = 0
>  hid-debug: input ffbc.0025 = 0
>  hid-debug: input ffbc.005a = 0
>  hid-debug: input ffbc.002e = 0
>  hid-debug: input ffbc.0028 = 0
>  hid-debug: input ffbc.002b = 0
>  hid-debug: input ffbc.004d = 0
>  hid-debug: input ffbc.004c = 0
>  hid-debug: input ffbc.0050 = 0
>  hid-debug: input ffbc.002d = 0
>  hid-debug: input ffbc.0024 = 0
>  hid-debug: input ffbc.000d = 1
>  hid-debug: input ffbc.005b = 0
>  hid-debug: input ffbc.005c = 0
>  hid-debug: input ffbc.005d = 0
>  hid-debug: input ffbc.005e = 0
>  hid-debug: input ffbc.003e = 0
>  hid-debug: input ffbc.003f = 0
>  hid-debug: input ffbc.0040 = 0
>  hid-debug: input ffbc.0031 = 0
>  hid-debug: input ffbc.004b = 0
>  hid-debug: input ffbc.0047 = 0
>  hid-debug: input ffbc.0049 = 0
>  hid-debug: input ffbc.006a = 0
>  hid-debug: input ffbc.002c = 0
>  hid-debug: input ffbc.0044 = 0
>  hid-debug: input ffbc.0081 = 0
>  hid-debug: input ffbc.006f = 0
>  hid-debug: input ffbc.0048 = 0
>  hid-debug: input ffbc.004a = 0
>  hid-debug: input ffbc.003c = 0
>  hid-debug: input ffbc.003d = 0
>  hid-debug: input ffbc.0032 = 0
>  hid-debug: input ffbc.0033 = 0
>  hid-debug: input ffbc.0034 = 0
>  hid-debug: input ffbc.0035 = 0
>  hid-debug: input ffbc.0036 = 0
>  hid-debug: input ffbc.0037 = 0
>  hid-debug: input ffbc.0038 = 0
>  hid-debug: input ffbc.0039 = 0
>  hid-debug: input ffbc.003a = 0
>  hid-debug: input ffbc.0080 = 0
>  hid-debug: input ffbc.0052 = 0
>  hid-debug: input ffbc.0053 = 0
>  hid-debug: input ffbc.0054 = 0
>  hid-debug: input ffbc.0055 = 0
>  hid-debug: input ffbc.0056 = 0
>  hid-debug: input ffbc.0058 = 0
>  hid-debug: input ffbc.0057 = 0
>  hid-debug: input ffbc.0059 = 0
>  hid-debug: input ffbc.0051 = 0
>  hid-debug: input ffbc.0030 = 0
>  hid-debug: input ffbc.002f = 0
>  hid-debug: input ffbc.0027 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  drivers/hid/hid-core.c: report (size 9) (numbered)
>  drivers/hid/hid-core.c: report 3 (size 9) =  03 00 00 00 00 00 00 00 00
>  hid-debug: input ffbc.0042 = 0
>  hid-debug: input ffbc.0041 = 0
>  hid-debug: input ffbc.004f = 0
>  hid-debug: input ffbc.0025 = 0
>  hid-debug: input ffbc.005a = 0
>  hid-debug: input ffbc.002e = 0
>  hid-debug: input ffbc.0028 = 0
>  hid-debug: input ffbc.002b = 0
>  hid-debug: input ffbc.004d = 0
>  hid-debug: input ffbc.004c = 0
>  hid-debug: input ffbc.0050 = 0
>  hid-debug: input ffbc.002d = 0
>  hid-debug: input ffbc.0024 = 0
>  hid-debug: input ffbc.000d = 0
>  hid-debug: input ffbc.005b = 0
>  hid-debug: input ffbc.005c = 0
>  hid-debug: input ffbc.005d = 0
>  hid-debug: input ffbc.005e = 0
>  hid-debug: input ffbc.003e = 0
>  hid-debug: input ffbc.003f = 0
>  hid-debug: input ffbc.0040 = 0
>  hid-debug: input ffbc.0031 = 0
>  hid-debug: input ffbc.004b = 0
>  hid-debug: input ffbc.0047 = 0
>  hid-debug: input ffbc.0049 = 0
>  hid-debug: input ffbc.006a = 0
>  hid-debug: input ffbc.002c = 0
>  hid-debug: input ffbc.0044 = 0
>  hid-debug: input ffbc.0081 = 0
>  hid-debug: input ffbc.006f = 0
>  hid-debug: input ffbc.0048 = 0
>  hid-debug: input ffbc.004a = 0
>  hid-debug: input ffbc.003c = 0
>  hid-debug: input ffbc.003d = 0
>  hid-debug: input ffbc.0032 = 0
>  hid-debug: input ffbc.0033 = 0
>  hid-debug: input ffbc.0034 = 0
>  hid-debug: input ffbc.0035 = 0
>  hid-debug: input ffbc.0036 = 0
>  hid-debug: input ffbc.0037 = 0
>  hid-debug: input ffbc.0038 = 0
>  hid-debug: input ffbc.0039 = 0
>  hid-debug: input ffbc.003a = 0
>  hid-debug: input ffbc.0080 = 0
>  hid-debug: input ffbc.0052 = 0
>  hid-debug: input ffbc.0053 = 0
>  hid-debug: input ffbc.0054 = 0
>  hid-debug: input ffbc.0055 = 0
>  hid-debug: input ffbc.0056 = 0
>  hid-debug: input ffbc.0058 = 0
>  hid-debug: input ffbc.0057 = 0
>  hid-debug: input ffbc.0059 = 0
>  hid-debug: input ffbc.0051 = 0
>  hid-debug: input ffbc.0030 = 0
>  hid-debug: input ffbc.002f = 0
>  hid-debug: input ffbc.0027 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  drivers/hid/hid-core.c: report (size 9) (numbered)
>  drivers/hid/hid-core.c: report 3 (size 9) =  03 00 00 00 40 00 00 00 00
>  hid-debug: input ffbc.0042 = 0
>  hid-debug: input ffbc.0041 = 0
>  hid-debug: input ffbc.004f = 0
>  hid-debug: input ffbc.0025 = 0
>  hid-debug: input ffbc.005a = 0
>  hid-debug: input ffbc.002e = 0
>  hid-debug: input ffbc.0028 = 0
>  hid-debug: input ffbc.002b = 0
>  hid-debug: input ffbc.004d = 0
>  hid-debug: input ffbc.004c = 0
>  hid-debug: input ffbc.0050 = 0
>  hid-debug: input ffbc.002d = 0
>  hid-debug: input ffbc.0024 = 0
>  hid-debug: input ffbc.000d = 0
>  hid-debug: input ffbc.005b = 0
>  hid-debug: input ffbc.005c = 0
>  hid-debug: input ffbc.005d = 0
>  hid-debug: input ffbc.005e = 0
>  hid-debug: input ffbc.003e = 0
>  hid-debug: input ffbc.003f = 0
>  hid-debug: input ffbc.0040 = 0
>  hid-debug: input ffbc.0031 = 0
>  hid-debug: input ffbc.004b = 0
>  hid-debug: input ffbc.0047 = 0
>  hid-debug: input ffbc.0049 = 0
>  hid-debug: input ffbc.006a = 0
>  hid-debug: input ffbc.002c = 0
>  hid-debug: input ffbc.0044 = 0
>  hid-debug: input ffbc.0081 = 0
>  hid-debug: input ffbc.006f = 0
>  hid-debug: input ffbc.0048 = 1
>  hid-debug: input ffbc.004a = 0
>  hid-debug: input ffbc.003c = 0
>  hid-debug: input ffbc.003d = 0
>  hid-debug: input ffbc.0032 = 0
>  hid-debug: input ffbc.0033 = 0
>  hid-debug: input ffbc.0034 = 0
>  hid-debug: input ffbc.0035 = 0
>  hid-debug: input ffbc.0036 = 0
>  hid-debug: input ffbc.0037 = 0
>  hid-debug: input ffbc.0038 = 0
>  hid-debug: input ffbc.0039 = 0
>  hid-debug: input ffbc.003a = 0
>  hid-debug: input ffbc.0080 = 0
>  hid-debug: input ffbc.0052 = 0
>  hid-debug: input ffbc.0053 = 0
>  hid-debug: input ffbc.0054 = 0
>  hid-debug: input ffbc.0055 = 0
>  hid-debug: input ffbc.0056 = 0
>  hid-debug: input ffbc.0058 = 0
>  hid-debug: input ffbc.0057 = 0
>  hid-debug: input ffbc.0059 = 0
>  hid-debug: input ffbc.0051 = 0
>  hid-debug: input ffbc.0030 = 0
>  hid-debug: input ffbc.002f = 0
>  hid-debug: input ffbc.0027 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  drivers/hid/hid-core.c: report (size 9) (numbered)
>  drivers/hid/hid-core.c: report 3 (size 9) =  03 00 00 00 00 00 00 00 00
>  hid-debug: input ffbc.0042 = 0
>  hid-debug: input ffbc.0041 = 0
>  hid-debug: input ffbc.004f = 0
>  hid-debug: input ffbc.0025 = 0
>  hid-debug: input ffbc.005a = 0
>  hid-debug: input ffbc.002e = 0
>  hid-debug: input ffbc.0028 = 0
>  hid-debug: input ffbc.002b = 0
>  hid-debug: input ffbc.004d = 0
>  hid-debug: input ffbc.004c = 0
>  hid-debug: input ffbc.0050 = 0
>  hid-debug: input ffbc.002d = 0
>  hid-debug: input ffbc.0024 = 0
>  hid-debug: input ffbc.000d = 0
>  hid-debug: input ffbc.005b = 0
>  hid-debug: input ffbc.005c = 0
>  hid-debug: input ffbc.005d = 0
>  hid-debug: input ffbc.005e = 0
>  hid-debug: input ffbc.003e = 0
>  hid-debug: input ffbc.003f = 0
>  hid-debug: input ffbc.0040 = 0
>  hid-debug: input ffbc.0031 = 0
>  hid-debug: input ffbc.004b = 0
>  hid-debug: input ffbc.0047 = 0
>  hid-debug: input ffbc.0049 = 0
>  hid-debug: input ffbc.006a = 0
>  hid-debug: input ffbc.002c = 0
>  hid-debug: input ffbc.0044 = 0
>  hid-debug: input ffbc.0081 = 0
>  hid-debug: input ffbc.006f = 0
>  hid-debug: input ffbc.0048 = 0
>  hid-debug: input ffbc.004a = 0
>  hid-debug: input ffbc.003c = 0
>  hid-debug: input ffbc.003d = 0
>  hid-debug: input ffbc.0032 = 0
>  hid-debug: input ffbc.0033 = 0
>  hid-debug: input ffbc.0034 = 0
>  hid-debug: input ffbc.0035 = 0
>  hid-debug: input ffbc.0036 = 0
>  hid-debug: input ffbc.0037 = 0
>  hid-debug: input ffbc.0038 = 0
>  hid-debug: input ffbc.0039 = 0
>  hid-debug: input ffbc.003a = 0
>  hid-debug: input ffbc.0080 = 0
>  hid-debug: input ffbc.0052 = 0
>  hid-debug: input ffbc.0053 = 0
>  hid-debug: input ffbc.0054 = 0
>  hid-debug: input ffbc.0055 = 0
>  hid-debug: input ffbc.0056 = 0
>  hid-debug: input ffbc.0058 = 0
>  hid-debug: input ffbc.0057 = 0
>  hid-debug: input ffbc.0059 = 0
>  hid-debug: input ffbc.0051 = 0
>  hid-debug: input ffbc.0030 = 0
>  hid-debug: input ffbc.002f = 0
>  hid-debug: input ffbc.0027 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  drivers/hid/hid-core.c: report (size 9) (numbered)
>  drivers/hid/hid-core.c: report 3 (size 9) =  03 08 00 00 00 00 00 00 00
>  hid-debug: input ffbc.0042 = 0
>  hid-debug: input ffbc.0041 = 0
>  hid-debug: input ffbc.004f = 0
>  hid-debug: input ffbc.0025 = 1
>  hid-debug: input ffbc.005a = 0
>  hid-debug: input ffbc.002e = 0
>  hid-debug: input ffbc.0028 = 0
>  hid-debug: input ffbc.002b = 0
>  hid-debug: input ffbc.004d = 0
>  hid-debug: input ffbc.004c = 0
>  hid-debug: input ffbc.0050 = 0
>  hid-debug: input ffbc.002d = 0
>  hid-debug: input ffbc.0024 = 0
>  hid-debug: input ffbc.000d = 0
>  hid-debug: input ffbc.005b = 0
>  hid-debug: input ffbc.005c = 0
>  hid-debug: input ffbc.005d = 0
>  hid-debug: input ffbc.005e = 0
>  hid-debug: input ffbc.003e = 0
>  hid-debug: input ffbc.003f = 0
>  hid-debug: input ffbc.0040 = 0
>  hid-debug: input ffbc.0031 = 0
>  hid-debug: input ffbc.004b = 0
>  hid-debug: input ffbc.0047 = 0
>  hid-debug: input ffbc.0049 = 0
>  hid-debug: input ffbc.006a = 0
>  hid-debug: input ffbc.002c = 0
>  hid-debug: input ffbc.0044 = 0
>  hid-debug: input ffbc.0081 = 0
>  hid-debug: input ffbc.006f = 0
>  hid-debug: input ffbc.0048 = 0
>  hid-debug: input ffbc.004a = 0
>  hid-debug: input ffbc.003c = 0
>  hid-debug: input ffbc.003d = 0
>  hid-debug: input ffbc.0032 = 0
>  hid-debug: input ffbc.0033 = 0
>  hid-debug: input ffbc.0034 = 0
>  hid-debug: input ffbc.0035 = 0
>  hid-debug: input ffbc.0036 = 0
>  hid-debug: input ffbc.0037 = 0
>  hid-debug: input ffbc.0038 = 0
>  hid-debug: input ffbc.0039 = 0
>  hid-debug: input ffbc.003a = 0
>  hid-debug: input ffbc.0080 = 0
>  hid-debug: input ffbc.0052 = 0
>  hid-debug: input ffbc.0053 = 0
>  hid-debug: input ffbc.0054 = 0
>  hid-debug: input ffbc.0055 = 0
>  hid-debug: input ffbc.0056 = 0
>  hid-debug: input ffbc.0058 = 0
>  hid-debug: input ffbc.0057 = 0
>  hid-debug: input ffbc.0059 = 0
>  hid-debug: input ffbc.0051 = 0
>  hid-debug: input ffbc.0030 = 0
>  hid-debug: input ffbc.002f = 0
>  hid-debug: input ffbc.0027 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  drivers/hid/hid-core.c: report (size 9) (numbered)
>  drivers/hid/hid-core.c: report 3 (size 9) =  03 00 00 00 00 00 00 00 00
>  hid-debug: input ffbc.0042 = 0
>  hid-debug: input ffbc.0041 = 0
>  hid-debug: input ffbc.004f = 0
>  hid-debug: input ffbc.0025 = 0
>  hid-debug: input ffbc.005a = 0
>  hid-debug: input ffbc.002e = 0
>  hid-debug: input ffbc.0028 = 0
>  hid-debug: input ffbc.002b = 0
>  hid-debug: input ffbc.004d = 0
>  hid-debug: input ffbc.004c = 0
>  hid-debug: input ffbc.0050 = 0
>  hid-debug: input ffbc.002d = 0
>  hid-debug: input ffbc.0024 = 0
>  hid-debug: input ffbc.000d = 0
>  hid-debug: input ffbc.005b = 0
>  hid-debug: input ffbc.005c = 0
>  hid-debug: input ffbc.005d = 0
>  hid-debug: input ffbc.005e = 0
>  hid-debug: input ffbc.003e = 0
>  hid-debug: input ffbc.003f = 0
>  hid-debug: input ffbc.0040 = 0
>  hid-debug: input ffbc.0031 = 0
>  hid-debug: input ffbc.004b = 0
>  hid-debug: input ffbc.0047 = 0
>  hid-debug: input ffbc.0049 = 0
>  hid-debug: input ffbc.006a = 0
>  hid-debug: input ffbc.002c = 0
>  hid-debug: input ffbc.0044 = 0
>  hid-debug: input ffbc.0081 = 0
>  hid-debug: input ffbc.006f = 0
>  hid-debug: input ffbc.0048 = 0
>  hid-debug: input ffbc.004a = 0
>  hid-debug: input ffbc.003c = 0
>  hid-debug: input ffbc.003d = 0
>  hid-debug: input ffbc.0032 = 0
>  hid-debug: input ffbc.0033 = 0
>  hid-debug: input ffbc.0034 = 0
>  hid-debug: input ffbc.0035 = 0
>  hid-debug: input ffbc.0036 = 0
>  hid-debug: input ffbc.0037 = 0
>  hid-debug: input ffbc.0038 = 0
>  hid-debug: input ffbc.0039 = 0
>  hid-debug: input ffbc.003a = 0
>  hid-debug: input ffbc.0080 = 0
>  hid-debug: input ffbc.0052 = 0
>  hid-debug: input ffbc.0053 = 0
>  hid-debug: input ffbc.0054 = 0
>  hid-debug: input ffbc.0055 = 0
>  hid-debug: input ffbc.0056 = 0
>  hid-debug: input ffbc.0058 = 0
>  hid-debug: input ffbc.0057 = 0
>  hid-debug: input ffbc.0059 = 0
>  hid-debug: input ffbc.0051 = 0
>  hid-debug: input ffbc.0030 = 0
>  hid-debug: input ffbc.002f = 0
>  hid-debug: input ffbc.0027 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  drivers/hid/hid-core.c: report (size 9) (numbered)
>  drivers/hid/hid-core.c: report 3 (size 9) =  03 00 10 00 00 00 00 00 00
>  hid-debug: input ffbc.0042 = 0
>  hid-debug: input ffbc.0041 = 0
>  hid-debug: input ffbc.004f = 0
>  hid-debug: input ffbc.0025 = 0
>  hid-debug: input ffbc.005a = 0
>  hid-debug: input ffbc.002e = 0
>  hid-debug: input ffbc.0028 = 0
>  hid-debug: input ffbc.002b = 0
>  hid-debug: input ffbc.004d = 0
>  hid-debug: input ffbc.004c = 0
>  hid-debug: input ffbc.0050 = 0
>  hid-debug: input ffbc.002d = 0
>  hid-debug: input ffbc.0024 = 1
>  hid-debug: input ffbc.000d = 0
>  hid-debug: input ffbc.005b = 0
>  hid-debug: input ffbc.005c = 0
>  hid-debug: input ffbc.005d = 0
>  hid-debug: input ffbc.005e = 0
>  hid-debug: input ffbc.003e = 0
>  hid-debug: input ffbc.003f = 0
>  hid-debug: input ffbc.0040 = 0
>  hid-debug: input ffbc.0031 = 0
>  hid-debug: input ffbc.004b = 0
>  hid-debug: input ffbc.0047 = 0
>  hid-debug: input ffbc.0049 = 0
>  hid-debug: input ffbc.006a = 0
>  hid-debug: input ffbc.002c = 0
>  hid-debug: input ffbc.0044 = 0
>  hid-debug: input ffbc.0081 = 0
>  hid-debug: input ffbc.006f = 0
>  hid-debug: input ffbc.0048 = 0
>  hid-debug: input ffbc.004a = 0
>  hid-debug: input ffbc.003c = 0
>  hid-debug: input ffbc.003d = 0
>  hid-debug: input ffbc.0032 = 0
>  hid-debug: input ffbc.0033 = 0
>  hid-debug: input ffbc.0034 = 0
>  hid-debug: input ffbc.0035 = 0
>  hid-debug: input ffbc.0036 = 0
>  hid-debug: input ffbc.0037 = 0
>  hid-debug: input ffbc.0038 = 0
>  hid-debug: input ffbc.0039 = 0
>  hid-debug: input ffbc.003a = 0
>  hid-debug: input ffbc.0080 = 0
>  hid-debug: input ffbc.0052 = 0
>  hid-debug: input ffbc.0053 = 0
>  hid-debug: input ffbc.0054 = 0
>  hid-debug: input ffbc.0055 = 0
>  hid-debug: input ffbc.0056 = 0
>  hid-debug: input ffbc.0058 = 0
>  hid-debug: input ffbc.0057 = 0
>  hid-debug: input ffbc.0059 = 0
>  hid-debug: input ffbc.0051 = 0
>  hid-debug: input ffbc.0030 = 0
>  hid-debug: input ffbc.002f = 0
>  hid-debug: input ffbc.0027 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  drivers/hid/hid-core.c: report (size 9) (numbered)
>  drivers/hid/hid-core.c: report 3 (size 9) =  03 00 00 00 00 00 00 00 00
>  hid-debug: input ffbc.0042 = 0
>  hid-debug: input ffbc.0041 = 0
>  hid-debug: input ffbc.004f = 0
>  hid-debug: input ffbc.0025 = 0
>  hid-debug: input ffbc.005a = 0
>  hid-debug: input ffbc.002e = 0
>  hid-debug: input ffbc.0028 = 0
>  hid-debug: input ffbc.002b = 0
>  hid-debug: input ffbc.004d = 0
>  hid-debug: input ffbc.004c = 0
>  hid-debug: input ffbc.0050 = 0
>  hid-debug: input ffbc.002d = 0
>  hid-debug: input ffbc.0024 = 0
>  hid-debug: input ffbc.000d = 0
>  hid-debug: input ffbc.005b = 0
>  hid-debug: input ffbc.005c = 0
>  hid-debug: input ffbc.005d = 0
>  hid-debug: input ffbc.005e = 0
>  hid-debug: input ffbc.003e = 0
>  hid-debug: input ffbc.003f = 0
>  hid-debug: input ffbc.0040 = 0
>  hid-debug: input ffbc.0031 = 0
>  hid-debug: input ffbc.004b = 0
>  hid-debug: input ffbc.0047 = 0
>  hid-debug: input ffbc.0049 = 0
>  hid-debug: input ffbc.006a = 0
>  hid-debug: input ffbc.002c = 0
>  hid-debug: input ffbc.0044 = 0
>  hid-debug: input ffbc.0081 = 0
>  hid-debug: input ffbc.006f = 0
>  hid-debug: input ffbc.0048 = 0
>  hid-debug: input ffbc.004a = 0
>  hid-debug: input ffbc.003c = 0
>  hid-debug: input ffbc.003d = 0
>  hid-debug: input ffbc.0032 = 0
>  hid-debug: input ffbc.0033 = 0
>  hid-debug: input ffbc.0034 = 0
>  hid-debug: input ffbc.0035 = 0
>  hid-debug: input ffbc.0036 = 0
>  hid-debug: input ffbc.0037 = 0
>  hid-debug: input ffbc.0038 = 0
>  hid-debug: input ffbc.0039 = 0
>  hid-debug: input ffbc.003a = 0
>  hid-debug: input ffbc.0080 = 0
>  hid-debug: input ffbc.0052 = 0
>  hid-debug: input ffbc.0053 = 0
>  hid-debug: input ffbc.0054 = 0
>  hid-debug: input ffbc.0055 = 0
>  hid-debug: input ffbc.0056 = 0
>  hid-debug: input ffbc.0058 = 0
>  hid-debug: input ffbc.0057 = 0
>  hid-debug: input ffbc.0059 = 0
>  hid-debug: input ffbc.0051 = 0
>  hid-debug: input ffbc.0030 = 0
>  hid-debug: input ffbc.002f = 0
>  hid-debug: input ffbc.0027 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  drivers/hid/hid-core.c: report (size 9) (numbered)
>  drivers/hid/hid-core.c: report 3 (size 9) =  03 10 00 00 00 00 00 00 00
>  hid-debug: input ffbc.0042 = 0
>  hid-debug: input ffbc.0041 = 0
>  hid-debug: input ffbc.004f = 0
>  hid-debug: input ffbc.0025 = 0
>  hid-debug: input ffbc.005a = 1
>  hid-debug: input ffbc.002e = 0
>  hid-debug: input ffbc.0028 = 0
>  hid-debug: input ffbc.002b = 0
>  hid-debug: input ffbc.004d = 0
>  hid-debug: input ffbc.004c = 0
>  hid-debug: input ffbc.0050 = 0
>  hid-debug: input ffbc.002d = 0
>  hid-debug: input ffbc.0024 = 0
>  hid-debug: input ffbc.000d = 0
>  hid-debug: input ffbc.005b = 0
>  hid-debug: input ffbc.005c = 0
>  hid-debug: input ffbc.005d = 0
>  hid-debug: input ffbc.005e = 0
>  hid-debug: input ffbc.003e = 0
>  hid-debug: input ffbc.003f = 0
>  hid-debug: input ffbc.0040 = 0
>  hid-debug: input ffbc.0031 = 0
>  hid-debug: input ffbc.004b = 0
>  hid-debug: input ffbc.0047 = 0
>  hid-debug: input ffbc.0049 = 0
>  hid-debug: input ffbc.006a = 0
>  hid-debug: input ffbc.002c = 0
>  hid-debug: input ffbc.0044 = 0
>  hid-debug: input ffbc.0081 = 0
>  hid-debug: input ffbc.006f = 0
>  hid-debug: input ffbc.0048 = 0
>  hid-debug: input ffbc.004a = 0
>  hid-debug: input ffbc.003c = 0
>  hid-debug: input ffbc.003d = 0
>  hid-debug: input ffbc.0032 = 0
>  hid-debug: input ffbc.0033 = 0
>  hid-debug: input ffbc.0034 = 0
>  hid-debug: input ffbc.0035 = 0
>  hid-debug: input ffbc.0036 = 0
>  hid-debug: input ffbc.0037 = 0
>  hid-debug: input ffbc.0038 = 0
>  hid-debug: input ffbc.0039 = 0
>  hid-debug: input ffbc.003a = 0
>  hid-debug: input ffbc.0080 = 0
>  hid-debug: input ffbc.0052 = 0
>  hid-debug: input ffbc.0053 = 0
>  hid-debug: input ffbc.0054 = 0
>  hid-debug: input ffbc.0055 = 0
>  hid-debug: input ffbc.0056 = 0
>  hid-debug: input ffbc.0058 = 0
>  hid-debug: input ffbc.0057 = 0
>  hid-debug: input ffbc.0059 = 0
>  hid-debug: input ffbc.0051 = 0
>  hid-debug: input ffbc.0030 = 0
>  hid-debug: input ffbc.002f = 0
>  hid-debug: input ffbc.0027 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  drivers/hid/hid-core.c: report (size 9) (numbered)
>  drivers/hid/hid-core.c: report 3 (size 9) =  03 00 00 00 00 00 00 00 00
>  hid-debug: input ffbc.0042 = 0
>  hid-debug: input ffbc.0041 = 0
>  hid-debug: input ffbc.004f = 0
>  hid-debug: input ffbc.0025 = 0
>  hid-debug: input ffbc.005a = 0
>  hid-debug: input ffbc.002e = 0
>  hid-debug: input ffbc.0028 = 0
>  hid-debug: input ffbc.002b = 0
>  hid-debug: input ffbc.004d = 0
>  hid-debug: input ffbc.004c = 0
>  hid-debug: input ffbc.0050 = 0
>  hid-debug: input ffbc.002d = 0
>  hid-debug: input ffbc.0024 = 0
>  hid-debug: input ffbc.000d = 0
>  hid-debug: input ffbc.005b = 0
>  hid-debug: input ffbc.005c = 0
>  hid-debug: input ffbc.005d = 0
>  hid-debug: input ffbc.005e = 0
>  hid-debug: input ffbc.003e = 0
>  hid-debug: input ffbc.003f = 0
>  hid-debug: input ffbc.0040 = 0
>  hid-debug: input ffbc.0031 = 0
>  hid-debug: input ffbc.004b = 0
>  hid-debug: input ffbc.0047 = 0
>  hid-debug: input ffbc.0049 = 0
>  hid-debug: input ffbc.006a = 0
>  hid-debug: input ffbc.002c = 0
>  hid-debug: input ffbc.0044 = 0
>  hid-debug: input ffbc.0081 = 0
>  hid-debug: input ffbc.006f = 0
>  hid-debug: input ffbc.0048 = 0
>  hid-debug: input ffbc.004a = 0
>  hid-debug: input ffbc.003c = 0
>  hid-debug: input ffbc.003d = 0
>  hid-debug: input ffbc.0032 = 0
>  hid-debug: input ffbc.0033 = 0
>  hid-debug: input ffbc.0034 = 0
>  hid-debug: input ffbc.0035 = 0
>  hid-debug: input ffbc.0036 = 0
>  hid-debug: input ffbc.0037 = 0
>  hid-debug: input ffbc.0038 = 0
>  hid-debug: input ffbc.0039 = 0
>  hid-debug: input ffbc.003a = 0
>  hid-debug: input ffbc.0080 = 0
>  hid-debug: input ffbc.0052 = 0
>  hid-debug: input ffbc.0053 = 0
>  hid-debug: input ffbc.0054 = 0
>  hid-debug: input ffbc.0055 = 0
>  hid-debug: input ffbc.0056 = 0
>  hid-debug: input ffbc.0058 = 0
>  hid-debug: input ffbc.0057 = 0
>  hid-debug: input ffbc.0059 = 0
>  hid-debug: input ffbc.0051 = 0
>  hid-debug: input ffbc.0030 = 0
>  hid-debug: input ffbc.002f = 0
>  hid-debug: input ffbc.0027 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  drivers/hid/hid-core.c: report (size 9) (numbered)
>  drivers/hid/hid-core.c: report 3 (size 9) =  03 00 40 00 00 00 00 00 00
>  hid-debug: input ffbc.0042 = 0
>  hid-debug: input ffbc.0041 = 0
>  hid-debug: input ffbc.004f = 0
>  hid-debug: input ffbc.0025 = 0
>  hid-debug: input ffbc.005a = 0
>  hid-debug: input ffbc.002e = 0
>  hid-debug: input ffbc.0028 = 0
>  hid-debug: input ffbc.002b = 0
>  hid-debug: input ffbc.004d = 0
>  hid-debug: input ffbc.004c = 0
>  hid-debug: input ffbc.0050 = 0
>  hid-debug: input ffbc.002d = 0
>  hid-debug: input ffbc.0024 = 0
>  hid-debug: input ffbc.000d = 0
>  hid-debug: input ffbc.005b = 1
>  hid-debug: input ffbc.005c = 0
>  hid-debug: input ffbc.005d = 0
>  hid-debug: input ffbc.005e = 0
>  hid-debug: input ffbc.003e = 0
>  hid-debug: input ffbc.003f = 0
>  hid-debug: input ffbc.0040 = 0
>  hid-debug: input ffbc.0031 = 0
>  hid-debug: input ffbc.004b = 0
>  hid-debug: input ffbc.0047 = 0
>  hid-debug: input ffbc.0049 = 0
>  hid-debug: input ffbc.006a = 0
>  hid-debug: input ffbc.002c = 0
>  hid-debug: input ffbc.0044 = 0
>  hid-debug: input ffbc.0081 = 0
>  hid-debug: input ffbc.006f = 0
>  hid-debug: input ffbc.0048 = 0
>  hid-debug: input ffbc.004a = 0
>  hid-debug: input ffbc.003c = 0
>  hid-debug: input ffbc.003d = 0
>  hid-debug: input ffbc.0032 = 0
>  hid-debug: input ffbc.0033 = 0
>  hid-debug: input ffbc.0034 = 0
>  hid-debug: input ffbc.0035 = 0
>  hid-debug: input ffbc.0036 = 0
>  hid-debug: input ffbc.0037 = 0
>  hid-debug: input ffbc.0038 = 0
>  hid-debug: input ffbc.0039 = 0
>  hid-debug: input ffbc.003a = 0
>  hid-debug: input ffbc.0080 = 0
>  hid-debug: input ffbc.0052 = 0
>  hid-debug: input ffbc.0053 = 0
>  hid-debug: input ffbc.0054 = 0
>  hid-debug: input ffbc.0055 = 0
>  hid-debug: input ffbc.0056 = 0
>  hid-debug: input ffbc.0058 = 0
>  hid-debug: input ffbc.0057 = 0
>  hid-debug: input ffbc.0059 = 0
>  hid-debug: input ffbc.0051 = 0
>  hid-debug: input ffbc.0030 = 0
>  hid-debug: input ffbc.002f = 0
>  hid-debug: input ffbc.0027 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  drivers/hid/hid-core.c: report (size 9) (numbered)
>  drivers/hid/hid-core.c: report 3 (size 9) =  03 00 00 00 00 00 00 00 00
>  hid-debug: input ffbc.0042 = 0
>  hid-debug: input ffbc.0041 = 0
>  hid-debug: input ffbc.004f = 0
>  hid-debug: input ffbc.0025 = 0
>  hid-debug: input ffbc.005a = 0
>  hid-debug: input ffbc.002e = 0
>  hid-debug: input ffbc.0028 = 0
>  hid-debug: input ffbc.002b = 0
>  hid-debug: input ffbc.004d = 0
>  hid-debug: input ffbc.004c = 0
>  hid-debug: input ffbc.0050 = 0
>  hid-debug: input ffbc.002d = 0
>  hid-debug: input ffbc.0024 = 0
>  hid-debug: input ffbc.000d = 0
>  hid-debug: input ffbc.005b = 0
>  hid-debug: input ffbc.005c = 0
>  hid-debug: input ffbc.005d = 0
>  hid-debug: input ffbc.005e = 0
>  hid-debug: input ffbc.003e = 0
>  hid-debug: input ffbc.003f = 0
>  hid-debug: input ffbc.0040 = 0
>  hid-debug: input ffbc.0031 = 0
>  hid-debug: input ffbc.004b = 0
>  hid-debug: input ffbc.0047 = 0
>  hid-debug: input ffbc.0049 = 0
>  hid-debug: input ffbc.006a = 0
>  hid-debug: input ffbc.002c = 0
>  hid-debug: input ffbc.0044 = 0
>  hid-debug: input ffbc.0081 = 0
>  hid-debug: input ffbc.006f = 0
>  hid-debug: input ffbc.0048 = 0
>  hid-debug: input ffbc.004a = 0
>  hid-debug: input ffbc.003c = 0
>  hid-debug: input ffbc.003d = 0
>  hid-debug: input ffbc.0032 = 0
>  hid-debug: input ffbc.0033 = 0
>  hid-debug: input ffbc.0034 = 0
>  hid-debug: input ffbc.0035 = 0
>  hid-debug: input ffbc.0036 = 0
>  hid-debug: input ffbc.0037 = 0
>  hid-debug: input ffbc.0038 = 0
>  hid-debug: input ffbc.0039 = 0
>  hid-debug: input ffbc.003a = 0
>  hid-debug: input ffbc.0080 = 0
>  hid-debug: input ffbc.0052 = 0
>  hid-debug: input ffbc.0053 = 0
>  hid-debug: input ffbc.0054 = 0
>  hid-debug: input ffbc.0055 = 0
>  hid-debug: input ffbc.0056 = 0
>  hid-debug: input ffbc.0058 = 0
>  hid-debug: input ffbc.0057 = 0
>  hid-debug: input ffbc.0059 = 0
>  hid-debug: input ffbc.0051 = 0
>  hid-debug: input ffbc.0030 = 0
>  hid-debug: input ffbc.002f = 0
>  hid-debug: input ffbc.0027 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  drivers/hid/hid-core.c: report (size 9) (numbered)
>  drivers/hid/hid-core.c: report 3 (size 9) =  03 00 80 00 00 00 00 00 00
>  hid-debug: input ffbc.0042 = 0
>  hid-debug: input ffbc.0041 = 0
>  hid-debug: input ffbc.004f = 0
>  hid-debug: input ffbc.0025 = 0
>  hid-debug: input ffbc.005a = 0
>  hid-debug: input ffbc.002e = 0
>  hid-debug: input ffbc.0028 = 0
>  hid-debug: input ffbc.002b = 0
>  hid-debug: input ffbc.004d = 0
>  hid-debug: input ffbc.004c = 0
>  hid-debug: input ffbc.0050 = 0
>  hid-debug: input ffbc.002d = 0
>  hid-debug: input ffbc.0024 = 0
>  hid-debug: input ffbc.000d = 0
>  hid-debug: input ffbc.005b = 0
>  hid-debug: input ffbc.005c = 1
>  hid-debug: input ffbc.005d = 0
>  hid-debug: input ffbc.005e = 0
>  hid-debug: input ffbc.003e = 0
>  hid-debug: input ffbc.003f = 0
>  hid-debug: input ffbc.0040 = 0
>  hid-debug: input ffbc.0031 = 0
>  hid-debug: input ffbc.004b = 0
>  hid-debug: input ffbc.0047 = 0
>  hid-debug: input ffbc.0049 = 0
>  hid-debug: input ffbc.006a = 0
>  hid-debug: input ffbc.002c = 0
>  hid-debug: input ffbc.0044 = 0
>  hid-debug: input ffbc.0081 = 0
>  hid-debug: input ffbc.006f = 0
>  hid-debug: input ffbc.0048 = 0
>  hid-debug: input ffbc.004a = 0
>  hid-debug: input ffbc.003c = 0
>  hid-debug: input ffbc.003d = 0
>  hid-debug: input ffbc.0032 = 0
>  hid-debug: input ffbc.0033 = 0
>  hid-debug: input ffbc.0034 = 0
>  hid-debug: input ffbc.0035 = 0
>  hid-debug: input ffbc.0036 = 0
>  hid-debug: input ffbc.0037 = 0
>  hid-debug: input ffbc.0038 = 0
>  hid-debug: input ffbc.0039 = 0
>  hid-debug: input ffbc.003a = 0
>  hid-debug: input ffbc.0080 = 0
>  hid-debug: input ffbc.0052 = 0
>  hid-debug: input ffbc.0053 = 0
>  hid-debug: input ffbc.0054 = 0
>  hid-debug: input ffbc.0055 = 0
>  hid-debug: input ffbc.0056 = 0
>  hid-debug: input ffbc.0058 = 0
>  hid-debug: input ffbc.0057 = 0
>  hid-debug: input ffbc.0059 = 0
>  hid-debug: input ffbc.0051 = 0
>  hid-debug: input ffbc.0030 = 0
>  hid-debug: input ffbc.002f = 0
>  hid-debug: input ffbc.0027 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  drivers/hid/hid-core.c: report (size 9) (numbered)
>  drivers/hid/hid-core.c: report 3 (size 9) =  03 00 00 00 00 00 00 00 00
>  hid-debug: input ffbc.0042 = 0
>  hid-debug: input ffbc.0041 = 0
>  hid-debug: input ffbc.004f = 0
>  hid-debug: input ffbc.0025 = 0
>  hid-debug: input ffbc.005a = 0
>  hid-debug: input ffbc.002e = 0
>  hid-debug: input ffbc.0028 = 0
>  hid-debug: input ffbc.002b = 0
>  hid-debug: input ffbc.004d = 0
>  hid-debug: input ffbc.004c = 0
>  hid-debug: input ffbc.0050 = 0
>  hid-debug: input ffbc.002d = 0
>  hid-debug: input ffbc.0024 = 0
>  hid-debug: input ffbc.000d = 0
>  hid-debug: input ffbc.005b = 0
>  hid-debug: input ffbc.005c = 0
>  hid-debug: input ffbc.005d = 0
>  hid-debug: input ffbc.005e = 0
>  hid-debug: input ffbc.003e = 0
>  hid-debug: input ffbc.003f = 0
>  hid-debug: input ffbc.0040 = 0
>  hid-debug: input ffbc.0031 = 0
>  hid-debug: input ffbc.004b = 0
>  hid-debug: input ffbc.0047 = 0
>  hid-debug: input ffbc.0049 = 0
>  hid-debug: input ffbc.006a = 0
>  hid-debug: input ffbc.002c = 0
>  hid-debug: input ffbc.0044 = 0
>  hid-debug: input ffbc.0081 = 0
>  hid-debug: input ffbc.006f = 0
>  hid-debug: input ffbc.0048 = 0
>  hid-debug: input ffbc.004a = 0
>  hid-debug: input ffbc.003c = 0
>  hid-debug: input ffbc.003d = 0
>  hid-debug: input ffbc.0032 = 0
>  hid-debug: input ffbc.0033 = 0
>  hid-debug: input ffbc.0034 = 0
>  hid-debug: input ffbc.0035 = 0
>  hid-debug: input ffbc.0036 = 0
>  hid-debug: input ffbc.0037 = 0
>  hid-debug: input ffbc.0038 = 0
>  hid-debug: input ffbc.0039 = 0
>  hid-debug: input ffbc.003a = 0
>  hid-debug: input ffbc.0080 = 0
>  hid-debug: input ffbc.0052 = 0
>  hid-debug: input ffbc.0053 = 0
>  hid-debug: input ffbc.0054 = 0
>  hid-debug: input ffbc.0055 = 0
>  hid-debug: input ffbc.0056 = 0
>  hid-debug: input ffbc.0058 = 0
>  hid-debug: input ffbc.0057 = 0
>  hid-debug: input ffbc.0059 = 0
>  hid-debug: input ffbc.0051 = 0
>  hid-debug: input ffbc.0030 = 0
>  hid-debug: input ffbc.002f = 0
>  hid-debug: input ffbc.0027 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  drivers/hid/hid-core.c: report (size 9) (numbered)
>  drivers/hid/hid-core.c: report 3 (size 9) =  03 00 00 01 00 00 00 00 00
>  hid-debug: input ffbc.0042 = 0
>  hid-debug: input ffbc.0041 = 0
>  hid-debug: input ffbc.004f = 0
>  hid-debug: input ffbc.0025 = 0
>  hid-debug: input ffbc.005a = 0
>  hid-debug: input ffbc.002e = 0
>  hid-debug: input ffbc.0028 = 0
>  hid-debug: input ffbc.002b = 0
>  hid-debug: input ffbc.004d = 0
>  hid-debug: input ffbc.004c = 0
>  hid-debug: input ffbc.0050 = 0
>  hid-debug: input ffbc.002d = 0
>  hid-debug: input ffbc.0024 = 0
>  hid-debug: input ffbc.000d = 0
>  hid-debug: input ffbc.005b = 0
>  hid-debug: input ffbc.005c = 0
>  hid-debug: input ffbc.005d = 1
>  hid-debug: input ffbc.005e = 0
>  hid-debug: input ffbc.003e = 0
>  hid-debug: input ffbc.003f = 0
>  hid-debug: input ffbc.0040 = 0
>  hid-debug: input ffbc.0031 = 0
>  hid-debug: input ffbc.004b = 0
>  hid-debug: input ffbc.0047 = 0
>  hid-debug: input ffbc.0049 = 0
>  hid-debug: input ffbc.006a = 0
>  hid-debug: input ffbc.002c = 0
>  hid-debug: input ffbc.0044 = 0
>  hid-debug: input ffbc.0081 = 0
>  hid-debug: input ffbc.006f = 0
>  hid-debug: input ffbc.0048 = 0
>  hid-debug: input ffbc.004a = 0
>  hid-debug: input ffbc.003c = 0
>  hid-debug: input ffbc.003d = 0
>  hid-debug: input ffbc.0032 = 0
>  hid-debug: input ffbc.0033 = 0
>  hid-debug: input ffbc.0034 = 0
>  hid-debug: input ffbc.0035 = 0
>  hid-debug: input ffbc.0036 = 0
>  hid-debug: input ffbc.0037 = 0
>  hid-debug: input ffbc.0038 = 0
>  hid-debug: input ffbc.0039 = 0
>  hid-debug: input ffbc.003a = 0
>  hid-debug: input ffbc.0080 = 0
>  hid-debug: input ffbc.0052 = 0
>  hid-debug: input ffbc.0053 = 0
>  hid-debug: input ffbc.0054 = 0
>  hid-debug: input ffbc.0055 = 0
>  hid-debug: input ffbc.0056 = 0
>  hid-debug: input ffbc.0058 = 0
>  hid-debug: input ffbc.0057 = 0
>  hid-debug: input ffbc.0059 = 0
>  hid-debug: input ffbc.0051 = 0
>  hid-debug: input ffbc.0030 = 0
>  hid-debug: input ffbc.002f = 0
>  hid-debug: input ffbc.0027 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  drivers/hid/hid-core.c: report (size 9) (numbered)
>  drivers/hid/hid-core.c: report 3 (size 9) =  03 00 00 00 00 00 00 00 00
>  hid-debug: input ffbc.0042 = 0
>  hid-debug: input ffbc.0041 = 0
>  hid-debug: input ffbc.004f = 0
>  hid-debug: input ffbc.0025 = 0
>  hid-debug: input ffbc.005a = 0
>  hid-debug: input ffbc.002e = 0
>  hid-debug: input ffbc.0028 = 0
>  hid-debug: input ffbc.002b = 0
>  hid-debug: input ffbc.004d = 0
>  hid-debug: input ffbc.004c = 0
>  hid-debug: input ffbc.0050 = 0
>  hid-debug: input ffbc.002d = 0
>  hid-debug: input ffbc.0024 = 0
>  hid-debug: input ffbc.000d = 0
>  hid-debug: input ffbc.005b = 0
>  hid-debug: input ffbc.005c = 0
>  hid-debug: input ffbc.005d = 0
>  hid-debug: input ffbc.005e = 0
>  hid-debug: input ffbc.003e = 0
>  hid-debug: input ffbc.003f = 0
>  hid-debug: input ffbc.0040 = 0
>  hid-debug: input ffbc.0031 = 0
>  hid-debug: input ffbc.004b = 0
>  hid-debug: input ffbc.0047 = 0
>  hid-debug: input ffbc.0049 = 0
>  hid-debug: input ffbc.006a = 0
>  hid-debug: input ffbc.002c = 0
>  hid-debug: input ffbc.0044 = 0
>  hid-debug: input ffbc.0081 = 0
>  hid-debug: input ffbc.006f = 0
>  hid-debug: input ffbc.0048 = 0
>  hid-debug: input ffbc.004a = 0
>  hid-debug: input ffbc.003c = 0
>  hid-debug: input ffbc.003d = 0
>  hid-debug: input ffbc.0032 = 0
>  hid-debug: input ffbc.0033 = 0
>  hid-debug: input ffbc.0034 = 0
>  hid-debug: input ffbc.0035 = 0
>  hid-debug: input ffbc.0036 = 0
>  hid-debug: input ffbc.0037 = 0
>  hid-debug: input ffbc.0038 = 0
>  hid-debug: input ffbc.0039 = 0
>  hid-debug: input ffbc.003a = 0
>  hid-debug: input ffbc.0080 = 0
>  hid-debug: input ffbc.0052 = 0
>  hid-debug: input ffbc.0053 = 0
>  hid-debug: input ffbc.0054 = 0
>  hid-debug: input ffbc.0055 = 0
>  hid-debug: input ffbc.0056 = 0
>  hid-debug: input ffbc.0058 = 0
>  hid-debug: input ffbc.0057 = 0
>  hid-debug: input ffbc.0059 = 0
>  hid-debug: input ffbc.0051 = 0
>  hid-debug: input ffbc.0030 = 0
>  hid-debug: input ffbc.002f = 0
>  hid-debug: input ffbc.0027 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  drivers/hid/hid-core.c: report (size 9) (numbered)
>  drivers/hid/hid-core.c: report 3 (size 9) =  03 00 00 02 00 00 00 00 00
>  hid-debug: input ffbc.0042 = 0
>  hid-debug: input ffbc.0041 = 0
>  hid-debug: input ffbc.004f = 0
>  hid-debug: input ffbc.0025 = 0
>  hid-debug: input ffbc.005a = 0
>  hid-debug: input ffbc.002e = 0
>  hid-debug: input ffbc.0028 = 0
>  hid-debug: input ffbc.002b = 0
>  hid-debug: input ffbc.004d = 0
>  hid-debug: input ffbc.004c = 0
>  hid-debug: input ffbc.0050 = 0
>  hid-debug: input ffbc.002d = 0
>  hid-debug: input ffbc.0024 = 0
>  hid-debug: input ffbc.000d = 0
>  hid-debug: input ffbc.005b = 0
>  hid-debug: input ffbc.005c = 0
>  hid-debug: input ffbc.005d = 0
>  hid-debug: input ffbc.005e = 1
>  hid-debug: input ffbc.003e = 0
>  hid-debug: input ffbc.003f = 0
>  hid-debug: input ffbc.0040 = 0
>  hid-debug: input ffbc.0031 = 0
>  hid-debug: input ffbc.004b = 0
>  hid-debug: input ffbc.0047 = 0
>  hid-debug: input ffbc.0049 = 0
>  hid-debug: input ffbc.006a = 0
>  hid-debug: input ffbc.002c = 0
>  hid-debug: input ffbc.0044 = 0
>  hid-debug: input ffbc.0081 = 0
>  hid-debug: input ffbc.006f = 0
>  hid-debug: input ffbc.0048 = 0
>  hid-debug: input ffbc.004a = 0
>  hid-debug: input ffbc.003c = 0
>  hid-debug: input ffbc.003d = 0
>  hid-debug: input ffbc.0032 = 0
>  hid-debug: input ffbc.0033 = 0
>  hid-debug: input ffbc.0034 = 0
>  hid-debug: input ffbc.0035 = 0
>  hid-debug: input ffbc.0036 = 0
>  hid-debug: input ffbc.0037 = 0
>  hid-debug: input ffbc.0038 = 0
>  hid-debug: input ffbc.0039 = 0
>  hid-debug: input ffbc.003a = 0
>  hid-debug: input ffbc.0080 = 0
>  hid-debug: input ffbc.0052 = 0
>  hid-debug: input ffbc.0053 = 0
>  hid-debug: input ffbc.0054 = 0
>  hid-debug: input ffbc.0055 = 0
>  hid-debug: input ffbc.0056 = 0
>  hid-debug: input ffbc.0058 = 0
>  hid-debug: input ffbc.0057 = 0
>  hid-debug: input ffbc.0059 = 0
>  hid-debug: input ffbc.0051 = 0
>  hid-debug: input ffbc.0030 = 0
>  hid-debug: input ffbc.002f = 0
>  hid-debug: input ffbc.0027 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  drivers/hid/hid-core.c: report (size 9) (numbered)
>  drivers/hid/hid-core.c: report 3 (size 9) =  03 00 00 00 00 00 00 00 00
>  hid-debug: input ffbc.0042 = 0
>  hid-debug: input ffbc.0041 = 0
>  hid-debug: input ffbc.004f = 0
>  hid-debug: input ffbc.0025 = 0
>  hid-debug: input ffbc.005a = 0
>  hid-debug: input ffbc.002e = 0
>  hid-debug: input ffbc.0028 = 0
>  hid-debug: input ffbc.002b = 0
>  hid-debug: input ffbc.004d = 0
>  hid-debug: input ffbc.004c = 0
>  hid-debug: input ffbc.0050 = 0
>  hid-debug: input ffbc.002d = 0
>  hid-debug: input ffbc.0024 = 0
>  hid-debug: input ffbc.000d = 0
>  hid-debug: input ffbc.005b = 0
>  hid-debug: input ffbc.005c = 0
>  hid-debug: input ffbc.005d = 0
>  hid-debug: input ffbc.005e = 0
>  hid-debug: input ffbc.003e = 0
>  hid-debug: input ffbc.003f = 0
>  hid-debug: input ffbc.0040 = 0
>  hid-debug: input ffbc.0031 = 0
>  hid-debug: input ffbc.004b = 0
>  hid-debug: input ffbc.0047 = 0
>  hid-debug: input ffbc.0049 = 0
>  hid-debug: input ffbc.006a = 0
>  hid-debug: input ffbc.002c = 0
>  hid-debug: input ffbc.0044 = 0
>  hid-debug: input ffbc.0081 = 0
>  hid-debug: input ffbc.006f = 0
>  hid-debug: input ffbc.0048 = 0
>  hid-debug: input ffbc.004a = 0
>  hid-debug: input ffbc.003c = 0
>  hid-debug: input ffbc.003d = 0
>  hid-debug: input ffbc.0032 = 0
>  hid-debug: input ffbc.0033 = 0
>  hid-debug: input ffbc.0034 = 0
>  hid-debug: input ffbc.0035 = 0
>  hid-debug: input ffbc.0036 = 0
>  hid-debug: input ffbc.0037 = 0
>  hid-debug: input ffbc.0038 = 0
>  hid-debug: input ffbc.0039 = 0
>  hid-debug: input ffbc.003a = 0
>  hid-debug: input ffbc.0080 = 0
>  hid-debug: input ffbc.0052 = 0
>  hid-debug: input ffbc.0053 = 0
>  hid-debug: input ffbc.0054 = 0
>  hid-debug: input ffbc.0055 = 0
>  hid-debug: input ffbc.0056 = 0
>  hid-debug: input ffbc.0058 = 0
>  hid-debug: input ffbc.0057 = 0
>  hid-debug: input ffbc.0059 = 0
>  hid-debug: input ffbc.0051 = 0
>  hid-debug: input ffbc.0030 = 0
>  hid-debug: input ffbc.002f = 0
>  hid-debug: input ffbc.0027 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
>  hid-debug: input ffbc.0078 = 0
> 

-- 
Dmitry
