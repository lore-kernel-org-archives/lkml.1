Return-Path: <linux-kernel-owner+w=401wt.eu-S1752134AbXFNMU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbXFNMU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 08:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbXFNMUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 08:20:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:21194 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbXFNMUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 08:20:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer;
        b=KXInJzxnJGLnIjIlOI/FT4WtpBi0HUkZ/h92ZR9mnGPNMGPQY4gDVjUku5qidV64N+f+fAkxqhCNIg6kdK/3M2UDN1YXjVlSsPc4LufF+nFyaV+v5H3iqa0QcBZfPDSosrIPY2xvjD9NKdg5c8ylgPQTRqimlRhx8qjXxrw4TRA=
Subject: Re: USB remote control missing keycodes
From: Islam Amer <pharon@gmail.com>
Reply-To: pharon@gmail.com
To: Jiri Kosina <jikos@jikos.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0706131809530.23280@twin.jikos.cz>
References: <20070611101319.GA14284@DervishD> <466D2DF7.9020709@aladin.ro>
	 <1181563063.19258.11.camel@iamer-laptop>
	 <Pine.LNX.4.64.0706111656340.23280@twin.jikos.cz>
	 <1181743734.6163.1.camel@iamer-laptop>
	 <Pine.LNX.4.64.0706131654180.23280@twin.jikos.cz>
	 <d120d5000706130817v5b9291d4h8653ade63882d2bc@mail.gmail.com>
	 <Pine.LNX.4.64.0706131741420.23280@twin.jikos.cz>
	 <1181750326.6163.6.camel@iamer-laptop>
	 <Pine.LNX.4.64.0706131809530.23280@twin.jikos.cz>
Content-Type: multipart/mixed; boundary="=-kT/p/foOM/D40VsWIl5Y"
Date: Thu, 14 Jun 2007 15:19:57 +0300
Message-Id: <1181823597.6136.8.camel@iamer-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kT/p/foOM/D40VsWIl5Y
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, 2007-06-13 at 18:17 +0200, Jiri Kosina wrote:
> On Wed, 13 Jun 2007, Islam Amer wrote:
> 
> > Nevertheless the patch you sent got the "TXT" key to work but not the 
> > "BACK" key. Here are the codes for all of the non-functioning keys ( TXT 
> > , BACK , 4 COLOR keys ):
> 
> You should also be obtaining hid-debug dump of usage code -> input mapping 
> when the kernel is compiled with CONFIG_HID_DEBUG, just after the report 
> descriptor is dumped, something like
> 
> drivers/hid/usbhid/hid-core.c: report descriptor (size 55, read 55) = 05 
> 01 09 02 a1 01 09 01 a1 00 05 09 19 01 29 08 15 00 25 01 75 01 95 08 81 02 
> 05 01 09 30 09 31 09 38 15 81 25 7f 75 08 95 03 81 06 05 0c 0a 38 02 95 01 
> 81 06 c0 c0
>   INPUT[INPUT]
>     Field(0)
>       Physical(GenericDesktop.Pointer)
>       Usage(8)
>         Button.0001
>         Button.0002
>         Button.0003
>         Button.0004
> ... etc.
> 
> Could you please send it to me, it wasn't included in your previous dump 
> you sent me?
> 
> Thanks,
> 

Ok here is everything from dmesg after the point of plugging in the usb
IR receiver, which is quite lengthy so as an attachment.

Thanks for all the help.



--=-kT/p/foOM/D40VsWIl5Y
Content-Disposition: attachment; filename=dmesg
Content-Type: text/plain; name=dmesg; charset=utf-8
Content-Transfer-Encoding: 7bit

[  578.581094] usb 1-3: new low speed USB device using ohci_hcd and address 4
[  578.794364] PM: Adding info for usb:1-3
[  578.794456] PM: Adding info for No Bus:usbdev1.4_ep00
[  578.794485] usb 1-3: configuration #1 chosen from 1 choice
[  578.797374] PM: Adding info for usb:1-3:1.0
[  578.810297] drivers/usb/input/hid-core.c: report descriptor (size 246, read 246) =  15 00 25 01 05 01 09 80 a1 01 85 01 19 81 29 83 75 01 95 03 81 02 75 05 95 01 81 01 c0 05 0c 09 01 a1 01 85 04 19 00 2a f5 00 0a 09 02 0a 30 02 0a 2d 02 0a 2e 02 0a 24 02 15 00 26 f9 00 75 08 95 01 81 00 c0 05 01 09 02 a1 01 85 03 09 01 a1 00 05 09 19 01 29 03 15 00 25 01 75 01 95 03 81 02 75 05 95 01 81 01 05 01 09 30 09 31 15 81 25 7f 75 08 95 02 81 06 09 38 95 01 81 06 c0 c0 05 01 09 06 a1 01 85 02 05 07 19 e0 29 e7 15 00 25 01 75 01 95 08 81 02 19 00 2a ff 00 15 00 26 ff 00 75 08 95 03 81 00 05 08 25 01 19 01 29 05 75 01 95 05 91 02 75 03 95 01 91 01 c0 06 bc ff 09 88 a1 01 85 05 19 00 29 f0 15 00 26 f0 00 75 08 95 01 81 00 c0 06 80 ff 09 00 a1 01 85 06 75 08 95 04 15 00 26 ff 00 09 01 b1 82 09 01 81 82 95 07 09 02 91 82 c0
[  588.777799] drivers/usb/input/hid-core.c: usb_submit_urb(ctrl) failed
[  588.777811] drivers/usb/input/hid-core.c: timeout initializing reports
[  588.777817]   INPUT(1)[INPUT]
[  588.777823]     Field(0)
[  588.777828]       Usage(3)
[  588.777834]         GenericDesktop.SystemPowerDown
[  588.777845]         GenericDesktop.SystemSleep
[  588.777855]         GenericDesktop.SystemWakeUp
[  588.777866]       Logical Minimum(0)
[  588.777874]       Logical Maximum(1)
[  588.777881]       Report Size(1)
[  588.777915]       Report Count(3)
[  588.777926]       Report Offset(0)
[  588.777933]       Flags( Variable Absolute )
[  588.777967]   INPUT(4)[INPUT]
[  588.777972]     Field(0)
[  588.778000]       Usage(251)
[  588.778029]         Consumer.0000
[  588.778038]         Consumer.0001
[  588.778047]         Consumer.0002
[  588.778055]         Consumer.0003
[  588.778064]         Consumer.0004
[  588.778073]         Consumer.0005
[  588.778082]         Consumer.0006
[  588.778090]         Consumer.0007
[  588.778122]         Consumer.0008
[  588.778131]         Consumer.0009
[  588.778139]         Consumer.000a
[  588.778148]         Consumer.000b
[  588.778157]         Consumer.000c
[  588.778165]         Consumer.000d
[  588.778174]         Consumer.000e
[  588.778182]         Consumer.000f
[  588.778191]         Consumer.0010
[  588.778200]         Consumer.0011
[  588.778209]         Consumer.0012
[  588.778217]         Consumer.0013
[  588.778226]         Consumer.0014
[  588.778258]         Consumer.0015
[  588.778266]         Consumer.0016
[  588.778274]         Consumer.0017
[  588.778283]         Consumer.0018
[  588.778315]         Consumer.0019
[  588.778324]         Consumer.001a
[  588.778332]         Consumer.001b
[  588.778341]         Consumer.001c
[  588.778350]         Consumer.001d
[  588.778358]         Consumer.001e
[  588.778367]         Consumer.001f
[  588.778376]         Consumer.0020
[  588.778407]         Consumer.0021
[  588.778416]         Consumer.0022
[  588.778425]         Consumer.0023
[  588.778433]         Consumer.0024
[  588.778442]         Consumer.0025
[  588.778451]         Consumer.0026
[  588.778460]         Consumer.0027
[  588.778469]         Consumer.0028
[  588.778478]         Consumer.0029
[  588.778486]         Consumer.002a
[  588.778494]         Consumer.002b
[  588.778526]         Consumer.002c
[  588.778535]         Consumer.002d
[  588.778543]         Consumer.002e
[  588.778552]         Consumer.002f
[  588.778561]         Consumer.0030
[  588.778569]         Consumer.0031
[  588.778578]         Consumer.0032
[  588.778587]         Consumer.0033
[  588.778596]         Consumer.0034
[  588.778605]         Consumer.0035
[  588.778613]         Consumer.0036
[  588.778622]         Consumer.0037
[  588.778631]         Consumer.0038
[  588.778663]         Consumer.0039
[  588.778672]         Consumer.003a
[  588.778680]         Consumer.003b
[  588.778689]         Consumer.003c
[  588.778720]         Consumer.003d
[  588.778729]         Consumer.003e
[  588.778761]         Consumer.003f
[  588.778770]         Consumer.0040
[  588.778778]         Consumer.0041
[  588.778786]         Consumer.0042
[  588.778795]         Consumer.0043
[  588.778804]         Consumer.0044
[  588.778813]         Consumer.0045
[  588.778821]         Consumer.0046
[  588.778830]         Consumer.0047
[  588.778839]         Consumer.0048
[  588.778847]         Consumer.0049
[  588.778855]         Consumer.004a
[  588.778864]         Consumer.004b
[  588.778896]         Consumer.004c
[  588.778905]         Consumer.004d
[  588.778913]         Consumer.004e
[  588.778922]         Consumer.004f
[  588.778930]         Consumer.0050
[  588.778939]         Consumer.0051
[  588.778948]         Consumer.0052
[  588.778980]         Consumer.0053
[  588.779011]         Consumer.0054
[  588.779020]         Consumer.0055
[  588.779029]         Consumer.0056
[  588.779038]         Consumer.0057
[  588.779046]         Consumer.0058
[  588.779054]         Consumer.0059
[  588.779085]         Consumer.005a
[  588.779094]         Consumer.005b
[  588.779103]         Consumer.005c
[  588.779112]         Consumer.005d
[  588.779121]         Consumer.005e
[  588.779130]         Consumer.005f
[  588.779139]         Consumer.0060
[  588.779170]         Consumer.0061
[  588.779202]         Consumer.0062
[  588.779234]         Consumer.0063
[  588.779243]         Consumer.0064
[  588.779252]         Consumer.0065
[  588.779283]         Consumer.0066
[  588.779291]         Consumer.0067
[  588.779323]         Consumer.0068
[  588.779331]         Consumer.0069
[  588.779340]         Consumer.006a
[  588.779372]         Consumer.006b
[  588.779380]         Consumer.006c
[  588.779389]         Consumer.006d
[  588.779398]         Consumer.006e
[  588.779407]         Consumer.006f
[  588.779439]         Consumer.0070
[  588.779447]         Consumer.0071
[  588.779456]         Consumer.0072
[  588.779465]         Consumer.0073
[  588.779498]         Consumer.0074
[  588.779507]         Consumer.0075
[  588.779515]         Consumer.0076
[  588.779523]         Consumer.0077
[  588.779578]         Consumer.0078
[  588.779586]         Consumer.0079
[  588.779595]         Consumer.007a
[  588.779603]         Consumer.007b
[  588.779611]         Consumer.007c
[  588.779619]         Consumer.007d
[  588.779628]         Consumer.007e
[  588.779636]         Consumer.007f
[  588.779667]         Consumer.0080
[  588.779698]         Consumer.0081
[  588.779729]         Consumer.0082
[  588.779737]         Consumer.0083
[  588.779746]         Consumer.0084
[  588.779754]         Consumer.0085
[  588.779762]         Consumer.0086
[  588.779794]         Consumer.0087
[  588.779802]         Consumer.0088
[  588.779811]         Consumer.0089
[  588.779819]         Consumer.008a
[  588.779828]         Consumer.008b
[  588.779837]         Consumer.008c
[  588.779845]         Consumer.008d
[  588.779853]         Consumer.008e
[  588.779862]         Consumer.008f
[  588.779870]         Consumer.0090
[  588.779878]         Consumer.0091
[  588.779886]         Consumer.0092
[  588.779894]         Consumer.0093
[  588.779903]         Consumer.0094
[  588.779912]         Consumer.0095
[  588.779920]         Consumer.0096
[  588.779928]         Consumer.0097
[  588.779937]         Consumer.0098
[  588.779945]         Consumer.0099
[  588.779954]         Consumer.009a
[  588.779986]         Consumer.009b
[  588.779994]         Consumer.009c
[  588.780003]         Consumer.009d
[  588.780012]         Consumer.009e
[  588.780020]         Consumer.009f
[  588.780028]         Consumer.00a0
[  588.780036]         Consumer.00a1
[  588.780044]         Consumer.00a2
[  588.780053]         Consumer.00a3
[  588.780084]         Consumer.00a4
[  588.780092]         Consumer.00a5
[  588.780101]         Consumer.00a6
[  588.780109]         Consumer.00a7
[  588.780118]         Consumer.00a8
[  588.780127]         Consumer.00a9
[  588.780159]         Consumer.00aa
[  588.780167]         Consumer.00ab
[  588.780199]         Consumer.00ac
[  588.780207]         Consumer.00ad
[  588.780215]         Consumer.00ae
[  588.780224]         Consumer.00af
[  588.780232]         Consumer.00b0
[  588.780240]         Consumer.00b1
[  588.780248]         Consumer.00b2
[  588.780257]         Consumer.00b3
[  588.780266]         Consumer.00b4
[  588.780274]         Consumer.00b5
[  588.780282]         Consumer.00b6
[  588.780313]         Consumer.00b7
[  588.780322]         Consumer.00b8
[  588.780331]         Consumer.00b9
[  588.780339]         Consumer.00ba
[  588.780347]         Consumer.00bb
[  588.780356]         Consumer.00bc
[  588.780364]         Consumer.00bd
[  588.780374]         Consumer.00be
[  588.780382]         Consumer.00bf
[  588.780390]         Consumer.00c0
[  588.780399]         Consumer.00c1
[  588.780431]         Consumer.00c2
[  588.780462]         Consumer.00c3
[  588.780471]         Consumer.00c4
[  588.780502]         Consumer.00c5
[  588.780534]         Consumer.00c6
[  588.780542]         Consumer.00c7
[  588.780551]         Consumer.00c8
[  588.780559]         Consumer.00c9
[  588.780614]         Consumer.00ca
[  588.780622]         Consumer.00cb
[  588.780631]         Consumer.00cc
[  588.780639]         Consumer.00cd
[  588.780648]         Consumer.00ce
[  588.780656]         Consumer.00cf
[  588.780688]         Consumer.00d0
[  588.780696]         Consumer.00d1
[  588.780704]         Consumer.00d2
[  588.780713]         Consumer.00d3
[  588.780721]         Consumer.00d4
[  588.780729]         Consumer.00d5
[  588.780738]         Consumer.00d6
[  588.780747]         Consumer.00d7
[  588.780755]         Consumer.00d8
[  588.780764]         Consumer.00d9
[  588.780772]         Consumer.00da
[  588.780781]         Consumer.00db
[  588.780789]         Consumer.00dc
[  588.780798]         Consumer.00dd
[  588.780829]         Consumer.00de
[  588.780838]         Consumer.00df
[  588.780846]         Consumer.00e0
[  588.780855]         Consumer.00e1
[  588.780864]         Consumer.00e2
[  588.780872]         Consumer.00e3
[  588.780881]         Consumer.00e4
[  588.780888]         Consumer.00e5
[  588.780897]         Consumer.00e6
[  588.780905]         Consumer.00e7
[  588.780913]         Consumer.00e8
[  588.780922]         Consumer.00e9
[  588.780930]         Consumer.00ea
[  588.780939]         Consumer.00eb
[  588.780947]         Consumer.00ec
[  588.780956]         Consumer.00ed
[  588.780965]         Consumer.00ee
[  588.780973]         Consumer.00ef
[  588.780981]         Consumer.00f0
[  588.780990]         Consumer.00f1
[  588.780999]         Consumer.00f2
[  588.781007]         Consumer.00f3
[  588.781015]         Consumer.00f4
[  588.781046]         Consumer.00f5
[  588.781055]         Consumer.0209
[  588.781064]         Consumer.0230
[  588.781072]         Consumer.022d
[  588.781080]         Consumer.022e
[  588.781089]         Consumer.0224
[  588.781097]       Logical Minimum(0)
[  588.781104]       Logical Maximum(249)
[  588.781110]       Report Size(8)
[  588.781116]       Report Count(1)
[  588.781144]       Report Offset(0)
[  588.781150]       Flags( Array Absolute )
[  588.781161]   INPUT(3)[INPUT]
[  588.781190]     Field(0)
[  588.781195]       Physical(GenericDesktop.Pointer)
[  588.781203]       Usage(3)
[  588.781231]         Button.0001
[  588.781239]         Button.0002
[  588.781271]         Button.0003
[  588.781279]       Logical Minimum(0)
[  588.781308]       Logical Maximum(1)
[  588.781314]       Report Size(1)
[  588.781320]       Report Count(3)
[  588.781325]       Report Offset(0)
[  588.781331]       Flags( Variable Absolute )
[  588.781341]     Field(1)
[  588.781346]       Physical(GenericDesktop.Pointer)
[  588.781377]       Usage(2)
[  588.781383]         GenericDesktop.X
[  588.781414]         GenericDesktop.Y
[  588.781422]       Logical Minimum(-127)
[  588.781428]       Logical Maximum(127)
[  588.781434]       Report Size(8)
[  588.781440]       Report Count(2)
[  588.781445]       Report Offset(8)
[  588.781451]       Flags( Variable Relative )
[  588.781484]     Field(2)
[  588.781489]       Physical(GenericDesktop.Pointer)
[  588.781520]       Usage(1)
[  588.781526]         GenericDesktop.Wheel
[  588.781534]       Logical Minimum(-127)
[  588.781540]       Logical Maximum(127)
[  588.781545]       Report Size(8)
[  588.781551]       Report Count(1)
[  588.781557]       Report Offset(24)
[  588.781563]       Flags( Variable Relative )
[  588.781596]   INPUT(2)[INPUT]
[  588.781625]     Field(0)
[  588.781629]       Usage(8)
[  588.781635]         Keyboard.00e0
[  588.781643]         Keyboard.00e1
[  588.781675]         Keyboard.00e2
[  588.781684]         Keyboard.00e3
[  588.781692]         Keyboard.00e4
[  588.781701]         Keyboard.00e5
[  588.781732]         Keyboard.00e6
[  588.781741]         Keyboard.00e7
[  588.781749]       Logical Minimum(0)
[  588.781755]       Logical Maximum(1)
[  588.781768]       Report Size(1)
[  588.781774]       Report Count(8)
[  588.781780]       Report Offset(0)
[  588.781786]       Flags( Variable Absolute )
[  588.781798]     Field(1)
[  588.781803]       Usage(256)
[  588.781809]         Keyboard.0000
[  588.781817]         Keyboard.0001
[  588.781826]         Keyboard.0002
[  588.781835]         Keyboard.0003
[  588.781843]         Keyboard.0004
[  588.781852]         Keyboard.0005
[  588.781861]         Keyboard.0006
[  588.781869]         Keyboard.0007
[  588.781877]         Keyboard.0008
[  588.781886]         Keyboard.0009
[  588.781918]         Keyboard.000a
[  588.781926]         Keyboard.000b
[  588.781935]         Keyboard.000c
[  588.781944]         Keyboard.000d
[  588.781952]         Keyboard.000e
[  588.781961]         Keyboard.000f
[  588.781969]         Keyboard.0010
[  588.781978]         Keyboard.0011
[  588.781986]         Keyboard.0012
[  588.781995]         Keyboard.0013
[  588.782027]         Keyboard.0014
[  588.782035]         Keyboard.0015
[  588.782044]         Keyboard.0016
[  588.782053]         Keyboard.0017
[  588.782062]         Keyboard.0018
[  588.782070]         Keyboard.0019
[  588.782079]         Keyboard.001a
[  588.782087]         Keyboard.001b
[  588.782096]         Keyboard.001c
[  588.782104]         Keyboard.001d
[  588.782112]         Keyboard.001e
[  588.782121]         Keyboard.001f
[  588.782130]         Keyboard.0020
[  588.782140]         Keyboard.0021
[  588.782148]         Keyboard.0022
[  588.782157]         Keyboard.0023
[  588.782188]         Keyboard.0024
[  588.782220]         Keyboard.0025
[  588.782228]         Keyboard.0026
[  588.782237]         Keyboard.0027
[  588.782245]         Keyboard.0028
[  588.782253]         Keyboard.0029
[  588.782262]         Keyboard.002a
[  588.782271]         Keyboard.002b
[  588.782279]         Keyboard.002c
[  588.782288]         Keyboard.002d
[  588.782296]         Keyboard.002e
[  588.782304]         Keyboard.002f
[  588.782312]         Keyboard.0030
[  588.782344]         Keyboard.0031
[  588.782352]         Keyboard.0032
[  588.782383]         Keyboard.0033
[  588.782392]         Keyboard.0034
[  588.782401]         Keyboard.0035
[  588.782409]         Keyboard.0036
[  588.782418]         Keyboard.0037
[  588.782449]         Keyboard.0038
[  588.782458]         Keyboard.0039
[  588.782466]         Keyboard.003a
[  588.782475]         Keyboard.003b
[  588.782484]         Keyboard.003c
[  588.782492]         Keyboard.003d
[  588.782501]         Keyboard.003e
[  588.782533]         Keyboard.003f
[  588.782541]         Keyboard.0040
[  588.782550]         Keyboard.0041
[  588.782559]         Keyboard.0042
[  588.782567]         Keyboard.0043
[  588.782576]         Keyboard.0044
[  588.782584]         Keyboard.0045
[  588.782593]         Keyboard.0046
[  588.782601]         Keyboard.0047
[  588.782610]         Keyboard.0048
[  588.782618]         Keyboard.0049
[  588.782627]         Keyboard.004a
[  588.782635]         Keyboard.004b
[  588.782643]         Keyboard.004c
[  588.782652]         Keyboard.004d
[  588.782660]         Keyboard.004e
[  588.782669]         Keyboard.004f
[  588.782677]         Keyboard.0050
[  588.782685]         Keyboard.0051
[  588.782694]         Keyboard.0052
[  588.782702]         Keyboard.0053
[  588.782711]         Keyboard.0054
[  588.782720]         Keyboard.0055
[  588.782728]         Keyboard.0056
[  588.782738]         Keyboard.0057
[  588.782746]         Keyboard.0058
[  588.782755]         Keyboard.0059
[  588.782764]         Keyboard.005a
[  588.782772]         Keyboard.005b
[  588.782804]         Keyboard.005c
[  588.782813]         Keyboard.005d
[  588.782821]         Keyboard.005e
[  588.782829]         Keyboard.005f
[  588.782838]         Keyboard.0060
[  588.782847]         Keyboard.0061
[  588.782855]         Keyboard.0062
[  588.782864]         Keyboard.0063
[  588.782872]         Keyboard.0064
[  588.782880]         Keyboard.0065
[  588.782889]         Keyboard.0066
[  588.782897]         Keyboard.0067
[  588.782906]         Keyboard.0068
[  588.782914]         Keyboard.0069
[  588.782922]         Keyboard.006a
[  588.782931]         Keyboard.006b
[  588.782939]         Keyboard.006c
[  588.782947]         Keyboard.006d
[  588.782979]         Keyboard.006e
[  588.782987]         Keyboard.006f
[  588.782995]         Keyboard.0070
[  588.783027]         Keyboard.0071
[  588.783035]         Keyboard.0072
[  588.783044]         Keyboard.0073
[  588.783098]         Keyboard.0074
[  588.783107]         Keyboard.0075
[  588.783115]         Keyboard.0076
[  588.783124]         Keyboard.0077
[  588.783132]         Keyboard.0078
[  588.783141]         Keyboard.0079
[  588.783149]         Keyboard.007a
[  588.783158]         Keyboard.007b
[  588.783166]         Keyboard.007c
[  588.783175]         Keyboard.007d
[  588.783183]         Keyboard.007e
[  588.783192]         Keyboard.007f
[  588.783224]         Keyboard.0080
[  588.783255]         Keyboard.0081
[  588.783287]         Keyboard.0082
[  588.783295]         Keyboard.0083
[  588.783304]         Keyboard.0084
[  588.783312]         Keyboard.0085
[  588.783321]         Keyboard.0086
[  588.783329]         Keyboard.0087
[  588.783338]         Keyboard.0088
[  588.783347]         Keyboard.0089
[  588.783355]         Keyboard.008a
[  588.783364]         Keyboard.008b
[  588.783372]         Keyboard.008c
[  588.783381]         Keyboard.008d
[  588.783389]         Keyboard.008e
[  588.783397]         Keyboard.008f
[  588.783405]         Keyboard.0090
[  588.783415]         Keyboard.0091
[  588.783423]         Keyboard.0092
[  588.783432]         Keyboard.0093
[  588.783440]         Keyboard.0094
[  588.783448]         Keyboard.0095
[  588.783458]         Keyboard.0096
[  588.783466]         Keyboard.0097
[  588.783475]         Keyboard.0098
[  588.783483]         Keyboard.0099
[  588.783492]         Keyboard.009a
[  588.783500]         Keyboard.009b
[  588.783509]         Keyboard.009c
[  588.783518]         Keyboard.009d
[  588.783526]         Keyboard.009e
[  588.783534]         Keyboard.009f
[  588.783543]         Keyboard.00a0
[  588.783575]         Keyboard.00a1
[  588.783584]         Keyboard.00a2
[  588.783593]         Keyboard.00a3
[  588.783601]         Keyboard.00a4
[  588.783610]         Keyboard.00a5
[  588.783618]         Keyboard.00a6
[  588.783627]         Keyboard.00a7
[  588.783635]         Keyboard.00a8
[  588.783643]         Keyboard.00a9
[  588.783652]         Keyboard.00aa
[  588.783683]         Keyboard.00ab
[  588.783715]         Keyboard.00ac
[  588.783724]         Keyboard.00ad
[  588.783732]         Keyboard.00ae
[  588.783740]         Keyboard.00af
[  588.783748]         Keyboard.00b0
[  588.783780]         Keyboard.00b1
[  588.783789]         Keyboard.00b2
[  588.783820]         Keyboard.00b3
[  588.783829]         Keyboard.00b4
[  588.783837]         Keyboard.00b5
[  588.783846]         Keyboard.00b6
[  588.783854]         Keyboard.00b7
[  588.783886]         Keyboard.00b8
[  588.783894]         Keyboard.00b9
[  588.783926]         Keyboard.00ba
[  588.783934]         Keyboard.00bb
[  588.783943]         Keyboard.00bc
[  588.783974]         Keyboard.00bd
[  588.783983]         Keyboard.00be
[  588.783992]         Keyboard.00bf
[  588.784000]         Keyboard.00c0
[  588.784009]         Keyboard.00c1
[  588.784017]         Keyboard.00c2
[  588.784049]         Keyboard.00c3
[  588.784057]         Keyboard.00c4
[  588.784066]         Keyboard.00c5
[  588.784075]         Keyboard.00c6
[  588.784083]         Keyboard.00c7
[  588.784091]         Keyboard.00c8
[  588.784099]         Keyboard.00c9
[  588.784108]         Keyboard.00ca
[  588.784116]         Keyboard.00cb
[  588.784126]         Keyboard.00cc
[  588.784180]         Keyboard.00cd
[  588.784213]         Keyboard.00ce
[  588.784244]         Keyboard.00cf
[  588.784252]         Keyboard.00d0
[  588.784261]         Keyboard.00d1
[  588.784269]         Keyboard.00d2
[  588.784278]         Keyboard.00d3
[  588.784287]         Keyboard.00d4
[  588.784295]         Keyboard.00d5
[  588.784326]         Keyboard.00d6
[  588.784358]         Keyboard.00d7
[  588.784366]         Keyboard.00d8
[  588.784374]         Keyboard.00d9
[  588.784383]         Keyboard.00da
[  588.784392]         Keyboard.00db
[  588.784400]         Keyboard.00dc
[  588.784409]         Keyboard.00dd
[  588.784418]         Keyboard.00de
[  588.784427]         Keyboard.00df
[  588.784436]         Keyboard.00e0
[  588.784444]         Keyboard.00e1
[  588.784452]         Keyboard.00e2
[  588.784484]         Keyboard.00e3
[  588.784492]         Keyboard.00e4
[  588.784500]         Keyboard.00e5
[  588.784508]         Keyboard.00e6
[  588.784540]         Keyboard.00e7
[  588.784572]         Keyboard.00e8
[  588.784605]         Keyboard.00e9
[  588.784636]         Keyboard.00ea
[  588.784644]         Keyboard.00eb
[  588.784676]         Keyboard.00ec
[  588.784684]         Keyboard.00ed
[  588.784693]         Keyboard.00ee
[  588.784725]         Keyboard.00ef
[  588.784756]         Keyboard.00f0
[  588.784765]         Keyboard.00f1
[  588.784774]         Keyboard.00f2
[  588.784782]         Keyboard.00f3
[  588.784791]         Keyboard.00f4
[  588.784799]         Keyboard.00f5
[  588.784807]         Keyboard.00f6
[  588.784816]         Keyboard.00f7
[  588.784825]         Keyboard.00f8
[  588.784834]         Keyboard.00f9
[  588.784865]         Keyboard.00fa
[  588.784874]         Keyboard.00fb
[  588.784882]         Keyboard.00fc
[  588.784891]         Keyboard.00fd
[  588.784922]         Keyboard.00fe
[  588.784931]         Keyboard.00ff
[  588.784939]       Logical Minimum(0)
[  588.784945]       Logical Maximum(255)
[  588.784951]       Report Size(8)
[  588.784957]       Report Count(3)
[  588.784963]       Report Offset(8)
[  588.784969]       Flags( Array Absolute )
[  588.784979]   INPUT(5)[INPUT]
[  588.784986]     Field(0)
[  588.784991]       Usage(241)
[  588.784996]         ffbc.0000
[  588.785007]         ffbc.0001
[  588.785017]         ffbc.0002
[  588.785026]         ffbc.0003
[  588.785036]         ffbc.0004
[  588.785046]         ffbc.0005
[  588.785055]         ffbc.0006
[  588.785065]         ffbc.0007
[  588.785097]         ffbc.0008
[  588.785107]         ffbc.0009
[  588.785116]         ffbc.000a
[  588.785126]         ffbc.000b
[  588.785158]         ffbc.000c
[  588.785167]         ffbc.000d
[  588.785177]         ffbc.000e
[  588.785209]         ffbc.000f
[  588.785219]         ffbc.0010
[  588.785252]         ffbc.0011
[  588.785262]         ffbc.0012
[  588.785272]         ffbc.0013
[  588.785304]         ffbc.0014
[  588.785314]         ffbc.0015
[  588.785323]         ffbc.0016
[  588.785333]         ffbc.0017
[  588.785343]         ffbc.0018
[  588.785352]         ffbc.0019
[  588.785362]         ffbc.001a
[  588.785372]         ffbc.001b
[  588.785403]         ffbc.001c
[  588.785413]         ffbc.001d
[  588.785423]         ffbc.001e
[  588.785433]         ffbc.001f
[  588.785442]         ffbc.0020
[  588.785452]         ffbc.0021
[  588.785462]         ffbc.0022
[  588.785472]         ffbc.0023
[  588.785482]         ffbc.0024
[  588.785491]         ffbc.0025
[  588.785500]         ffbc.0026
[  588.785533]         ffbc.0027
[  588.785566]         ffbc.0028
[  588.785576]         ffbc.0029
[  588.785585]         ffbc.002a
[  588.785595]         ffbc.002b
[  588.785604]         ffbc.002c
[  588.785613]         ffbc.002d
[  588.785623]         ffbc.002e
[  588.785655]         ffbc.002f
[  588.785665]         ffbc.0030
[  588.785675]         ffbc.0031
[  588.785707]         ffbc.0032
[  588.785767]         ffbc.0033
[  588.785777]         ffbc.0034
[  588.785786]         ffbc.0035
[  588.785795]         ffbc.0036
[  588.785805]         ffbc.0037
[  588.785814]         ffbc.0038
[  588.785823]         ffbc.0039
[  588.785832]         ffbc.003a
[  588.785842]         ffbc.003b
[  588.785851]         ffbc.003c
[  588.785861]         ffbc.003d
[  588.785870]         ffbc.003e
[  588.785880]         ffbc.003f
[  588.785912]         ffbc.0040
[  588.785922]         ffbc.0041
[  588.785931]         ffbc.0042
[  588.785941]         ffbc.0043
[  588.785950]         ffbc.0044
[  588.785959]         ffbc.0045
[  588.785968]         ffbc.0046
[  588.785979]         ffbc.0047
[  588.785988]         ffbc.0048
[  588.785998]         ffbc.0049
[  588.786008]         ffbc.004a
[  588.786016]         ffbc.004b
[  588.786026]         ffbc.004c
[  588.786035]         ffbc.004d
[  588.786045]         ffbc.004e
[  588.786077]         ffbc.004f
[  588.786087]         ffbc.0050
[  588.786096]         ffbc.0051
[  588.786106]         ffbc.0052
[  588.786115]         ffbc.0053
[  588.786124]         ffbc.0054
[  588.786134]         ffbc.0055
[  588.786144]         ffbc.0056
[  588.786152]         ffbc.0057
[  588.786163]         ffbc.0058
[  588.786217]         ffbc.0059
[  588.786227]         ffbc.005a
[  588.786237]         ffbc.005b
[  588.786247]         ffbc.005c
[  588.786256]         ffbc.005d
[  588.786266]         ffbc.005e
[  588.786298]         ffbc.005f
[  588.786308]         ffbc.0060
[  588.786340]         ffbc.0061
[  588.786350]         ffbc.0062
[  588.786359]         ffbc.0063
[  588.786369]         ffbc.0064
[  588.786401]         ffbc.0065
[  588.786411]         ffbc.0066
[  588.786420]         ffbc.0067
[  588.786430]         ffbc.0068
[  588.786438]         ffbc.0069
[  588.786448]         ffbc.006a
[  588.786457]         ffbc.006b
[  588.786467]         ffbc.006c
[  588.786476]         ffbc.006d
[  588.786486]         ffbc.006e
[  588.786518]         ffbc.006f
[  588.786527]         ffbc.0070
[  588.786559]         ffbc.0071
[  588.786569]         ffbc.0072
[  588.786579]         ffbc.0073
[  588.786589]         ffbc.0074
[  588.786621]         ffbc.0075
[  588.786653]         ffbc.0076
[  588.786662]         ffbc.0077
[  588.786695]         ffbc.0078
[  588.786704]         ffbc.0079
[  588.786713]         ffbc.007a
[  588.786723]         ffbc.007b
[  588.786731]         ffbc.007c
[  588.786764]         ffbc.007d
[  588.786773]         ffbc.007e
[  588.786783]         ffbc.007f
[  588.786792]         ffbc.0080
[  588.786802]         ffbc.0081
[  588.786811]         ffbc.0082
[  588.786821]         ffbc.0083
[  588.786830]         ffbc.0084
[  588.786840]         ffbc.0085
[  588.786848]         ffbc.0086
[  588.786881]         ffbc.0087
[  588.786890]         ffbc.0088
[  588.786900]         ffbc.0089
[  588.786910]         ffbc.008a
[  588.786919]         ffbc.008b
[  588.786929]         ffbc.008c
[  588.786938]         ffbc.008d
[  588.786970]         ffbc.008e
[  588.786980]         ffbc.008f
[  588.787013]         ffbc.0090
[  588.787022]         ffbc.0091
[  588.787032]         ffbc.0092
[  588.787042]         ffbc.0093
[  588.787051]         ffbc.0094
[  588.787061]         ffbc.0095
[  588.787071]         ffbc.0096
[  588.787081]         ffbc.0097
[  588.787090]         ffbc.0098
[  588.787100]         ffbc.0099
[  588.787109]         ffbc.009a
[  588.787118]         ffbc.009b
[  588.787127]         ffbc.009c
[  588.787136]         ffbc.009d
[  588.787146]         ffbc.009e
[  588.787155]         ffbc.009f
[  588.787188]         ffbc.00a0
[  588.787197]         ffbc.00a1
[  588.787207]         ffbc.00a2
[  588.787216]         ffbc.00a3
[  588.787226]         ffbc.00a4
[  588.787235]         ffbc.00a5
[  588.787244]         ffbc.00a6
[  588.787254]         ffbc.00a7
[  588.787264]         ffbc.00a8
[  588.787296]         ffbc.00a9
[  588.787306]         ffbc.00aa
[  588.787314]         ffbc.00ab
[  588.787347]         ffbc.00ac
[  588.787380]         ffbc.00ad
[  588.787390]         ffbc.00ae
[  588.787399]         ffbc.00af
[  588.787408]         ffbc.00b0
[  588.787440]         ffbc.00b1
[  588.787450]         ffbc.00b2
[  588.787482]         ffbc.00b3
[  588.787491]         ffbc.00b4
[  588.787500]         ffbc.00b5
[  588.787511]         ffbc.00b6
[  588.787520]         ffbc.00b7
[  588.787529]         ffbc.00b8
[  588.787539]         ffbc.00b9
[  588.787548]         ffbc.00ba
[  588.787558]         ffbc.00bb
[  588.787567]         ffbc.00bc
[  588.787577]         ffbc.00bd
[  588.787587]         ffbc.00be
[  588.787596]         ffbc.00bf
[  588.787606]         ffbc.00c0
[  588.787639]         ffbc.00c1
[  588.787648]         ffbc.00c2
[  588.787658]         ffbc.00c3
[  588.787667]         ffbc.00c4
[  588.787677]         ffbc.00c5
[  588.787686]         ffbc.00c6
[  588.787718]         ffbc.00c7
[  588.787751]         ffbc.00c8
[  588.787760]         ffbc.00c9
[  588.787770]         ffbc.00ca
[  588.787780]         ffbc.00cb
[  588.787789]         ffbc.00cc
[  588.787821]         ffbc.00cd
[  588.787853]         ffbc.00ce
[  588.787863]         ffbc.00cf
[  588.787872]         ffbc.00d0
[  588.787881]         ffbc.00d1
[  588.787891]         ffbc.00d2
[  588.787901]         ffbc.00d3
[  588.787933]         ffbc.00d4
[  588.787943]         ffbc.00d5
[  588.787952]         ffbc.00d6
[  588.787961]         ffbc.00d7
[  588.787970]         ffbc.00d8
[  588.787981]         ffbc.00d9
[  588.788012]         ffbc.00da
[  588.788045]         ffbc.00db
[  588.788078]         ffbc.00dc
[  588.788088]         ffbc.00dd
[  588.788097]         ffbc.00de
[  588.788130]         ffbc.00df
[  588.788139]         ffbc.00e0
[  588.788149]         ffbc.00e1
[  588.788181]         ffbc.00e2
[  588.788214]         ffbc.00e3
[  588.788223]         ffbc.00e4
[  588.788233]         ffbc.00e5
[  588.788242]         ffbc.00e6
[  588.788252]         ffbc.00e7
[  588.788260]         ffbc.00e8
[  588.788270]         ffbc.00e9
[  588.788302]         ffbc.00ea
[  588.788335]         ffbc.00eb
[  588.788344]         ffbc.00ec
[  588.788377]         ffbc.00ed
[  588.788387]         ffbc.00ee
[  588.788397]         ffbc.00ef
[  588.788429]         ffbc.00f0
[  588.788439]       Logical Minimum(0)
[  588.788445]       Logical Maximum(240)
[  588.788451]       Report Size(8)
[  588.788480]       Report Count(1)
[  588.788508]       Report Offset(0)
[  588.788514]       Flags( Array Absolute )
[  588.788525]   INPUT(6)[INPUT]
[  588.788531]     Field(0)
[  588.788535]       Usage(4)
[  588.788541]         ff80.0001
[  588.788596]         ff80.0001
[  588.788628]         ff80.0001
[  588.788638]         ff80.0001
[  588.788648]       Logical Minimum(0)
[  588.788653]       Logical Maximum(255)
[  588.788659]       Report Size(8)
[  588.788664]       Report Count(4)
[  588.788693]       Report Offset(0)
[  588.788698]       Flags( Variable Absolute Volatile )
[  588.788710]   OUTPUT(2)[OUTPUT]
[  588.788715]     Field(0)
[  588.788719]       Usage(5)
[  588.788725]         LED.NumLock
[  588.788733]         LED.CapsLock
[  588.788741]         LED.ScrollLock
[  588.788773]         LED.Compose
[  588.788804]         LED.Kana
[  588.788812]       Logical Minimum(0)
[  588.788818]       Logical Maximum(1)
[  588.788824]       Report Size(1)
[  588.788830]       Report Count(5)
[  588.788836]       Report Offset(0)
[  588.788865]       Flags( Variable Absolute )
[  588.788875]   OUTPUT(6)[OUTPUT]
[  588.788881]     Field(0)
[  588.788885]       Usage(7)
[  588.788891]         ff80.0002
[  588.788900]         ff80.0002
[  588.788910]         ff80.0002
[  588.788919]         ff80.0002
[  588.788952]         ff80.0002
[  588.788984]         ff80.0002
[  588.788994]         ff80.0002
[  588.789026]       Logical Minimum(0)
[  588.789032]       Logical Maximum(255)
[  588.789038]       Report Size(8)
[  588.789043]       Report Count(7)
[  588.789049]       Report Offset(0)
[  588.789054]       Flags( Variable Absolute Volatile )
[  588.789088]   FEATURE(6)[FEATURE]
[  588.789094]     Field(0)
[  588.789098]       Usage(4)
[  588.789104]         ff80.0001
[  588.789113]         ff80.0001
[  588.789123]         ff80.0001
[  588.789132]         ff80.0001
[  588.789142]       Logical Minimum(0)
[  588.789171]       Logical Maximum(255)
[  588.789177]       Report Size(8)
[  588.789182]       Report Count(4)
[  588.789188]       Report Offset(0)
[  588.789193]       Flags( Variable Absolute Volatile )
[  588.789257] Mapping: GenericDesktop.SystemPowerDown ---> Key.Power
[  588.789268] Mapping: GenericDesktop.SystemSleep ---> Key.Sleep
[  588.789298] Mapping: GenericDesktop.SystemWakeUp ---> Key.WakeUp
[  588.789307] Mapping: Consumer.0000 ---> IGNORED
[  588.789313] Mapping: Consumer.0001 ---> IGNORED
[  588.789320] Mapping: Consumer.0002 ---> IGNORED
[  588.789326] Mapping: Consumer.0003 ---> IGNORED
[  588.789332] Mapping: Consumer.0004 ---> IGNORED
[  588.789339] Mapping: Consumer.0005 ---> IGNORED
[  588.789346] Mapping: Consumer.0006 ---> IGNORED
[  588.789353] Mapping: Consumer.0007 ---> IGNORED
[  588.789359] Mapping: Consumer.0008 ---> IGNORED
[  588.789365] Mapping: Consumer.0009 ---> IGNORED
[  588.789372] Mapping: Consumer.000a ---> IGNORED
[  588.789378] Mapping: Consumer.000b ---> IGNORED
[  588.789384] Mapping: Consumer.000c ---> IGNORED
[  588.789391] Mapping: Consumer.000d ---> IGNORED
[  588.789398] Mapping: Consumer.000e ---> IGNORED
[  588.789404] Mapping: Consumer.000f ---> IGNORED
[  588.789411] Mapping: Consumer.0010 ---> IGNORED
[  588.789417] Mapping: Consumer.0011 ---> IGNORED
[  588.789424] Mapping: Consumer.0012 ---> IGNORED
[  588.789430] Mapping: Consumer.0013 ---> IGNORED
[  588.789437] Mapping: Consumer.0014 ---> IGNORED
[  588.789443] Mapping: Consumer.0015 ---> IGNORED
[  588.789450] Mapping: Consumer.0016 ---> IGNORED
[  588.789457] Mapping: Consumer.0017 ---> IGNORED
[  588.789486] Mapping: Consumer.0018 ---> IGNORED
[  588.789493] Mapping: Consumer.0019 ---> IGNORED
[  588.789500] Mapping: Consumer.001a ---> IGNORED
[  588.789529] Mapping: Consumer.001b ---> IGNORED
[  588.789536] Mapping: Consumer.001c ---> IGNORED
[  588.789542] Mapping: Consumer.001d ---> IGNORED
[  588.789549] Mapping: Consumer.001e ---> IGNORED
[  588.789555] Mapping: Consumer.001f ---> IGNORED
[  588.789562] Mapping: Consumer.0020 ---> IGNORED
[  588.789568] Mapping: Consumer.0021 ---> IGNORED
[  588.789574] Mapping: Consumer.0022 ---> IGNORED
[  588.789581] Mapping: Consumer.0023 ---> IGNORED
[  588.789587] Mapping: Consumer.0024 ---> IGNORED
[  588.789594] Mapping: Consumer.0025 ---> IGNORED
[  588.789600] Mapping: Consumer.0026 ---> IGNORED
[  588.789607] Mapping: Consumer.0027 ---> IGNORED
[  588.789613] Mapping: Consumer.0028 ---> IGNORED
[  588.789620] Mapping: Consumer.0029 ---> IGNORED
[  588.789626] Mapping: Consumer.002a ---> IGNORED
[  588.789633] Mapping: Consumer.002b ---> IGNORED
[  588.789640] Mapping: Consumer.002c ---> IGNORED
[  588.789646] Mapping: Consumer.002d ---> IGNORED
[  588.789653] Mapping: Consumer.002e ---> IGNORED
[  588.789660] Mapping: Consumer.002f ---> IGNORED
[  588.789666] Mapping: Consumer.0030 ---> IGNORED
[  588.789673] Mapping: Consumer.0031 ---> IGNORED
[  588.789680] Mapping: Consumer.0032 ---> IGNORED
[  588.789687] Mapping: Consumer.0033 ---> IGNORED
[  588.789693] Mapping: Consumer.0034 ---> Key.Sleep
[  588.789724] Mapping: Consumer.0035 ---> IGNORED
[  588.789730] Mapping: Consumer.0036 ---> Key.Btn0
[  588.789743] Mapping: Consumer.0037 ---> IGNORED
[  588.789749] Mapping: Consumer.0038 ---> IGNORED
[  588.789756] Mapping: Consumer.0039 ---> IGNORED
[  588.789762] Mapping: Consumer.003a ---> IGNORED
[  588.789769] Mapping: Consumer.003b ---> IGNORED
[  588.789775] Mapping: Consumer.003c ---> IGNORED
[  588.789781] Mapping: Consumer.003d ---> IGNORED
[  588.789788] Mapping: Consumer.003e ---> IGNORED
[  588.789794] Mapping: Consumer.003f ---> IGNORED
[  588.789800] Mapping: Consumer.0040 ---> Key.Menu
[  588.789807] Mapping: Consumer.0041 ---> IGNORED
[  588.789814] Mapping: Consumer.0042 ---> IGNORED
[  588.789820] Mapping: Consumer.0043 ---> IGNORED
[  588.789826] Mapping: Consumer.0044 ---> IGNORED
[  588.789833] Mapping: Consumer.0045 ---> Key.Radio
[  588.789840] Mapping: Consumer.0046 ---> IGNORED
[  588.789847] Mapping: Consumer.0047 ---> IGNORED
[  588.789853] Mapping: Consumer.0048 ---> IGNORED
[  588.789859] Mapping: Consumer.0049 ---> IGNORED
[  588.789866] Mapping: Consumer.004a ---> IGNORED
[  588.789896] Mapping: Consumer.004b ---> IGNORED
[  588.789902] Mapping: Consumer.004c ---> IGNORED
[  588.789908] Mapping: Consumer.004d ---> IGNORED
[  588.789915] Mapping: Consumer.004e ---> IGNORED
[  588.789921] Mapping: Consumer.004f ---> IGNORED
[  588.789928] Mapping: Consumer.0050 ---> IGNORED
[  588.789934] Mapping: Consumer.0051 ---> IGNORED
[  588.789940] Mapping: Consumer.0052 ---> IGNORED
[  588.789946] Mapping: Consumer.0053 ---> IGNORED
[  588.789953] Mapping: Consumer.0054 ---> IGNORED
[  588.789959] Mapping: Consumer.0055 ---> IGNORED
[  588.789966] Mapping: Consumer.0056 ---> IGNORED
[  588.789972] Mapping: Consumer.0057 ---> IGNORED
[  588.789978] Mapping: Consumer.0058 ---> IGNORED
[  588.789985] Mapping: Consumer.0059 ---> IGNORED
[  588.789991] Mapping: Consumer.005a ---> IGNORED
[  588.789997] Mapping: Consumer.005b ---> IGNORED
[  588.790003] Mapping: Consumer.005c ---> IGNORED
[  588.790009] Mapping: Consumer.005d ---> IGNORED
[  588.790016] Mapping: Consumer.005e ---> IGNORED
[  588.790022] Mapping: Consumer.005f ---> IGNORED
[  588.790029] Mapping: Consumer.0060 ---> IGNORED
[  588.790035] Mapping: Consumer.0061 ---> IGNORED
[  588.790041] Mapping: Consumer.0062 ---> IGNORED
[  588.790048] Mapping: Consumer.0063 ---> IGNORED
[  588.790054] Mapping: Consumer.0064 ---> IGNORED
[  588.790060] Mapping: Consumer.0065 ---> IGNORED
[  588.790067] Mapping: Consumer.0066 ---> IGNORED
[  588.790073] Mapping: Consumer.0067 ---> IGNORED
[  588.790079] Mapping: Consumer.0068 ---> IGNORED
[  588.790085] Mapping: Consumer.0069 ---> IGNORED
[  588.790092] Mapping: Consumer.006a ---> IGNORED
[  588.790098] Mapping: Consumer.006b ---> IGNORED
[  588.790105] Mapping: Consumer.006c ---> IGNORED
[  588.790111] Mapping: Consumer.006d ---> IGNORED
[  588.790118] Mapping: Consumer.006e ---> IGNORED
[  588.790124] Mapping: Consumer.006f ---> IGNORED
[  588.790131] Mapping: Consumer.0070 ---> IGNORED
[  588.790138] Mapping: Consumer.0071 ---> IGNORED
[  588.790144] Mapping: Consumer.0072 ---> IGNORED
[  588.790150] Mapping: Consumer.0073 ---> IGNORED
[  588.790157] Mapping: Consumer.0074 ---> IGNORED
[  588.790163] Mapping: Consumer.0075 ---> IGNORED
[  588.790170] Mapping: Consumer.0076 ---> IGNORED
[  588.790176] Mapping: Consumer.0077 ---> IGNORED
[  588.790182] Mapping: Consumer.0078 ---> IGNORED
[  588.790189] Mapping: Consumer.0079 ---> IGNORED
[  588.790195] Mapping: Consumer.007a ---> IGNORED
[  588.790201] Mapping: Consumer.007b ---> IGNORED
[  588.790208] Mapping: Consumer.007c ---> IGNORED
[  588.790214] Mapping: Consumer.007d ---> IGNORED
[  588.790221] Mapping: Consumer.007e ---> IGNORED
[  588.790227] Mapping: Consumer.007f ---> IGNORED
[  588.790233] Mapping: Consumer.0080 ---> IGNORED
[  588.790240] Mapping: Consumer.0081 ---> IGNORED
[  588.790246] Mapping: Consumer.0082 ---> IGNORED
[  588.790252] Mapping: Consumer.0083 ---> Key.Last
[  588.790260] Mapping: Consumer.0084 ---> IGNORED
[  588.790266] Mapping: Consumer.0085 ---> IGNORED
[  588.790271] Mapping: Consumer.0086 ---> IGNORED
[  588.790277] Mapping: Consumer.0087 ---> IGNORED
[  588.790284] Mapping: Consumer.0088 ---> Key.PC
[  588.790292] Mapping: Consumer.0089 ---> Key.TV
[  588.790298] Mapping: Consumer.008a ---> Key.WWW
[  588.790306] Mapping: Consumer.008b ---> Key.DVD
[  588.790313] Mapping: Consumer.008c ---> Key.Phone
[  588.790320] Mapping: Consumer.008d ---> Key.Program
[  588.790327] Mapping: Consumer.008e ---> Key.?
[  588.790335] Mapping: Consumer.008f ---> Key.?
[  588.790342] Mapping: Consumer.0090 ---> Key.Memo
[  588.790349] Mapping: Consumer.0091 ---> Key.CD
[  588.790356] Mapping: Consumer.0092 ---> Key.VCR
[  588.790363] Mapping: Consumer.0093 ---> Key.Tuner
[  588.790370] Mapping: Consumer.0094 ---> Key.Exit
[  588.790377] Mapping: Consumer.0095 ---> Key.Help
[  588.790408] Mapping: Consumer.0096 ---> Key.Tape
[  588.790415] Mapping: Consumer.0097 ---> Key.TV2
[  588.790422] Mapping: Consumer.0098 ---> Key.Sat
[  588.790429] Mapping: Consumer.0099 ---> IGNORED
[  588.790436] Mapping: Consumer.009a ---> Key.PVR
[  588.790443] Mapping: Consumer.009b ---> IGNORED
[  588.790449] Mapping: Consumer.009c ---> Key.ChannelUp
[  588.790456] Mapping: Consumer.009d ---> Key.ChannelDown
[  588.790464] Mapping: Consumer.009e ---> IGNORED
[  588.790470] Mapping: Consumer.009f ---> IGNORED
[  588.790476] Mapping: Consumer.00a0 ---> Key.VCR2
[  588.790483] Mapping: Consumer.00a1 ---> IGNORED
[  588.790490] Mapping: Consumer.00a2 ---> IGNORED
[  588.790495] Mapping: Consumer.00a3 ---> IGNORED
[  588.790502] Mapping: Consumer.00a4 ---> IGNORED
[  588.790508] Mapping: Consumer.00a5 ---> IGNORED
[  588.790515] Mapping: Consumer.00a6 ---> IGNORED
[  588.790522] Mapping: Consumer.00a7 ---> IGNORED
[  588.790529] Mapping: Consumer.00a8 ---> IGNORED
[  588.790535] Mapping: Consumer.00a9 ---> IGNORED
[  588.790541] Mapping: Consumer.00aa ---> IGNORED
[  588.790547] Mapping: Consumer.00ab ---> IGNORED
[  588.790554] Mapping: Consumer.00ac ---> IGNORED
[  588.790560] Mapping: Consumer.00ad ---> IGNORED
[  588.790566] Mapping: Consumer.00ae ---> IGNORED
[  588.790572] Mapping: Consumer.00af ---> IGNORED
[  588.790579] Mapping: Consumer.00b0 ---> Key.Play
[  588.790587] Mapping: Consumer.00b1 ---> Key.Pause
[  588.790616] Mapping: Consumer.00b2 ---> Key.Record
[  588.790624] Mapping: Consumer.00b3 ---> Key.FastForward
[  588.790630] Mapping: Consumer.00b4 ---> Key.Rewind
[  588.790638] Mapping: Consumer.00b5 ---> Key.NextSong
[  588.790644] Mapping: Consumer.00b6 ---> Key.PreviousSong
[  588.790652] Mapping: Consumer.00b7 ---> Key.StopCD
[  588.790659] Mapping: Consumer.00b8 ---> Key.EjectCD
[  588.790665] Mapping: Consumer.00b9 ---> IGNORED
[  588.790672] Mapping: Consumer.00ba ---> IGNORED
[  588.790701] Mapping: Consumer.00bb ---> IGNORED
[  588.790707] Mapping: Consumer.00bc ---> IGNORED
[  588.790713] Mapping: Consumer.00bd ---> IGNORED
[  588.790720] Mapping: Consumer.00be ---> IGNORED
[  588.790726] Mapping: Consumer.00bf ---> IGNORED
[  588.790732] Mapping: Consumer.00c0 ---> IGNORED
[  588.790738] Mapping: Consumer.00c1 ---> IGNORED
[  588.790745] Mapping: Consumer.00c2 ---> IGNORED
[  588.790751] Mapping: Consumer.00c3 ---> IGNORED
[  588.790757] Mapping: Consumer.00c4 ---> IGNORED
[  588.790763] Mapping: Consumer.00c5 ---> IGNORED
[  588.790769] Mapping: Consumer.00c6 ---> IGNORED
[  588.790775] Mapping: Consumer.00c7 ---> IGNORED
[  588.790782] Mapping: Consumer.00c8 ---> IGNORED
[  588.790788] Mapping: Consumer.00c9 ---> IGNORED
[  588.790794] Mapping: Consumer.00ca ---> IGNORED
[  588.790800] Mapping: Consumer.00cb ---> IGNORED
[  588.790806] Mapping: Consumer.00cc ---> IGNORED
[  588.790813] Mapping: Consumer.00cd ---> Key.PlayPause
[  588.790820] Mapping: Consumer.00ce ---> IGNORED
[  588.790826] Mapping: Consumer.00cf ---> IGNORED
[  588.790832] Mapping: Consumer.00d0 ---> IGNORED
[  588.790838] Mapping: Consumer.00d1 ---> IGNORED
[  588.790845] Mapping: Consumer.00d2 ---> IGNORED
[  588.790851] Mapping: Consumer.00d3 ---> IGNORED
[  588.790858] Mapping: Consumer.00d4 ---> IGNORED
[  588.790864] Mapping: Consumer.00d5 ---> IGNORED
[  588.790870] Mapping: Consumer.00d6 ---> IGNORED
[  588.790875] Mapping: Consumer.00d7 ---> IGNORED
[  588.790881] Mapping: Consumer.00d8 ---> IGNORED
[  588.790910] Mapping: Consumer.00d9 ---> IGNORED
[  588.790917] Mapping: Consumer.00da ---> IGNORED
[  588.790923] Mapping: Consumer.00db ---> IGNORED
[  588.790929] Mapping: Consumer.00dc ---> IGNORED
[  588.790936] Mapping: Consumer.00dd ---> IGNORED
[  588.790942] Mapping: Consumer.00de ---> IGNORED
[  588.790948] Mapping: Consumer.00df ---> IGNORED
[  588.790954] Mapping: Consumer.00e0 ---> Absolute.Volume
[  588.790962] Mapping: Consumer.00e1 ---> IGNORED
[  588.790968] Mapping: Consumer.00e2 ---> Key.Mute
[  588.790975] Mapping: Consumer.00e3 ---> IGNORED
[  588.790981] Mapping: Consumer.00e4 ---> IGNORED
[  588.790987] Mapping: Consumer.00e5 ---> Key.BassBoost
[  588.790994] Mapping: Consumer.00e6 ---> IGNORED
[  588.791000] Mapping: Consumer.00e7 ---> IGNORED
[  588.791006] Mapping: Consumer.00e8 ---> IGNORED
[  588.791036] Mapping: Consumer.00e9 ---> Key.VolumeUp
[  588.791043] Mapping: Consumer.00ea ---> Key.VolumeDown
[  588.791050] Mapping: Consumer.00eb ---> IGNORED
[  588.791056] Mapping: Consumer.00ec ---> IGNORED
[  588.791062] Mapping: Consumer.00ed ---> IGNORED
[  588.791069] Mapping: Consumer.00ee ---> IGNORED
[  588.791075] Mapping: Consumer.00ef ---> IGNORED
[  588.791080] Mapping: Consumer.00f0 ---> IGNORED
[  588.791087] Mapping: Consumer.00f1 ---> IGNORED
[  588.791093] Mapping: Consumer.00f2 ---> IGNORED
[  588.791099] Mapping: Consumer.00f3 ---> IGNORED
[  588.791105] Mapping: Consumer.00f4 ---> IGNORED
[  588.791111] Mapping: Consumer.00f5 ---> IGNORED
[  588.791118] Mapping: Consumer.0209 ---> Key.Props
[  588.791125] Mapping: Consumer.0230 ---> IGNORED
[  588.791132] Mapping: Consumer.022d ---> Key.?
[  588.791138] Mapping: Consumer.022e ---> Key.?
[  588.791146] Mapping: Consumer.0224 ---> Key.Back
[  588.791152] Mapping: Button.0001 ---> Key.LeftBtn
[  588.791160] Mapping: Button.0002 ---> Key.RightBtn
[  588.791167] Mapping: Button.0003 ---> Key.MiddleBtn
[  588.791174] Mapping: GenericDesktop.X ---> Relative.X
[  588.791181] Mapping: GenericDesktop.Y ---> Relative.Y
[  588.791188] Mapping: GenericDesktop.Wheel ---> Relative.Wheel
[  588.791218] Mapping: Keyboard.00e0 ---> Key.LeftControl
[  588.791226] Mapping: Keyboard.00e1 ---> Key.LeftShift
[  588.791255] Mapping: Keyboard.00e2 ---> Key.LeftAlt
[  588.791263] Mapping: Keyboard.00e3 ---> Key.LeftMeta
[  588.791270] Mapping: Keyboard.00e4 ---> Key.RightCtrl
[  588.791301] Mapping: Keyboard.00e5 ---> Key.RightShift
[  588.791330] Mapping: Keyboard.00e6 ---> Key.RightAlt
[  588.791337] Mapping: Keyboard.00e7 ---> Key.RightMeta
[  588.791345] Mapping: Keyboard.0000 ---> IGNORED
[  588.791350] Mapping: Keyboard.0001 ---> IGNORED
[  588.791356] Mapping: Keyboard.0002 ---> IGNORED
[  588.791362] Mapping: Keyboard.0003 ---> IGNORED
[  588.791369] Mapping: Keyboard.0004 ---> Key.A
[  588.791376] Mapping: Keyboard.0005 ---> Key.B
[  588.791382] Mapping: Keyboard.0006 ---> Key.C
[  588.791390] Mapping: Keyboard.0007 ---> Key.D
[  588.791396] Mapping: Keyboard.0008 ---> Key.E
[  588.791403] Mapping: Keyboard.0009 ---> Key.F
[  588.791410] Mapping: Keyboard.000a ---> Key.G
[  588.791417] Mapping: Keyboard.000b ---> Key.H
[  588.791424] Mapping: Keyboard.000c ---> Key.I
[  588.791430] Mapping: Keyboard.000d ---> Key.J
[  588.791460] Mapping: Keyboard.000e ---> Key.K
[  588.791468] Mapping: Keyboard.000f ---> Key.L
[  588.791474] Mapping: Keyboard.0010 ---> Key.M
[  588.791481] Mapping: Keyboard.0011 ---> Key.N
[  588.791488] Mapping: Keyboard.0012 ---> Key.O
[  588.791495] Mapping: Keyboard.0013 ---> Key.P
[  588.791502] Mapping: Keyboard.0014 ---> Key.Q
[  588.791509] Mapping: Keyboard.0015 ---> Key.R
[  588.791515] Mapping: Keyboard.0016 ---> Key.S
[  588.791522] Mapping: Keyboard.0017 ---> Key.T
[  588.791529] Mapping: Keyboard.0018 ---> Key.U
[  588.791559] Mapping: Keyboard.0019 ---> Key.V
[  588.791566] Mapping: Keyboard.001a ---> Key.W
[  588.791573] Mapping: Keyboard.001b ---> Key.X
[  588.791580] Mapping: Keyboard.001c ---> Key.Y
[  588.791587] Mapping: Keyboard.001d ---> Key.Z
[  588.791593] Mapping: Keyboard.001e ---> Key.1
[  588.791600] Mapping: Keyboard.001f ---> Key.2
[  588.791607] Mapping: Keyboard.0020 ---> Key.3
[  588.791614] Mapping: Keyboard.0021 ---> Key.4
[  588.791622] Mapping: Keyboard.0022 ---> Key.5
[  588.791629] Mapping: Keyboard.0023 ---> Key.6
[  588.791635] Mapping: Keyboard.0024 ---> Key.7
[  588.791642] Mapping: Keyboard.0025 ---> Key.8
[  588.791649] Mapping: Keyboard.0026 ---> Key.9
[  588.791656] Mapping: Keyboard.0027 ---> Key.0
[  588.791663] Mapping: Keyboard.0028 ---> Key.Enter
[  588.791669] Mapping: Keyboard.0029 ---> Key.Esc
[  588.791676] Mapping: Keyboard.002a ---> Key.Backspace
[  588.791706] Mapping: Keyboard.002b ---> Key.Tab
[  588.791713] Mapping: Keyboard.002c ---> Key.Space
[  588.791743] Mapping: Keyboard.002d ---> Key.Minus
[  588.791750] Mapping: Keyboard.002e ---> Key.Equal
[  588.791757] Mapping: Keyboard.002f ---> Key.LeftBrace
[  588.791764] Mapping: Keyboard.0030 ---> Key.RightBrace
[  588.791771] Mapping: Keyboard.0031 ---> Key.BackSlash
[  588.791778] Mapping: Keyboard.0032 ---> Key.BackSlash
[  588.791784] Mapping: Keyboard.0033 ---> Key.Semicolon
[  588.791814] Mapping: Keyboard.0034 ---> Key.Apostrophe
[  588.791821] Mapping: Keyboard.0035 ---> Key.Grave
[  588.791852] Mapping: Keyboard.0036 ---> Key.Comma
[  588.791859] Mapping: Keyboard.0037 ---> Key.Dot
[  588.791865] Mapping: Keyboard.0038 ---> Key.Slash
[  588.791872] Mapping: Keyboard.0039 ---> Key.CapsLock
[  588.791878] Mapping: Keyboard.003a ---> Key.F1
[  588.791909] Mapping: Keyboard.003b ---> Key.F2
[  588.791916] Mapping: Keyboard.003c ---> Key.F3
[  588.791945] Mapping: Keyboard.003d ---> Key.F4
[  588.791952] Mapping: Keyboard.003e ---> Key.F5
[  588.791958] Mapping: Keyboard.003f ---> Key.F6
[  588.791965] Mapping: Keyboard.0040 ---> Key.F7
[  588.791972] Mapping: Keyboard.0041 ---> Key.F8
[  588.791979] Mapping: Keyboard.0042 ---> Key.F9
[  588.791986] Mapping: Keyboard.0043 ---> Key.F10
[  588.792016] Mapping: Keyboard.0044 ---> Key.F11
[  588.792022] Mapping: Keyboard.0045 ---> Key.F12
[  588.792030] Mapping: Keyboard.0046 ---> Key.SysRq
[  588.792036] Mapping: Keyboard.0047 ---> Key.ScrollLock
[  588.792044] Mapping: Keyboard.0048 ---> Key.Pause
[  588.792051] Mapping: Keyboard.0049 ---> Key.Insert
[  588.792058] Mapping: Keyboard.004a ---> Key.Home
[  588.792065] Mapping: Keyboard.004b ---> Key.PageUp
[  588.792072] Mapping: Keyboard.004c ---> Key.Delete
[  588.792101] Mapping: Keyboard.004d ---> Key.End
[  588.792132] Mapping: Keyboard.004e ---> Key.PageDown
[  588.792138] Mapping: Keyboard.004f ---> Key.Right
[  588.792145] Mapping: Keyboard.0050 ---> Key.Left
[  588.792151] Mapping: Keyboard.0051 ---> Key.Down
[  588.792158] Mapping: Keyboard.0052 ---> Key.Up
[  588.792164] Mapping: Keyboard.0053 ---> Key.NumLock
[  588.792171] Mapping: Keyboard.0054 ---> Key.KPSlash
[  588.792178] Mapping: Keyboard.0055 ---> Key.KPAsterisk
[  588.792185] Mapping: Keyboard.0056 ---> Key.KPMinus
[  588.792192] Mapping: Keyboard.0057 ---> Key.KPPlus
[  588.792199] Mapping: Keyboard.0058 ---> Key.KPEnter
[  588.792206] Mapping: Keyboard.0059 ---> Key.KP1
[  588.792213] Mapping: Keyboard.005a ---> Key.KP2
[  588.792220] Mapping: Keyboard.005b ---> Key.KP3
[  588.792226] Mapping: Keyboard.005c ---> Key.KP4
[  588.792257] Mapping: Keyboard.005d ---> Key.KP5
[  588.792263] Mapping: Keyboard.005e ---> Key.KP6
[  588.792270] Mapping: Keyboard.005f ---> Key.KP7
[  588.792277] Mapping: Keyboard.0060 ---> Key.KP8
[  588.792284] Mapping: Keyboard.0061 ---> Key.KP9
[  588.792290] Mapping: Keyboard.0062 ---> Key.KP0
[  588.792297] Mapping: Keyboard.0063 ---> Key.KPDot
[  588.792304] Mapping: Keyboard.0064 ---> Key.102nd
[  588.792311] Mapping: Keyboard.0065 ---> Key.Compose
[  588.792318] Mapping: Keyboard.0066 ---> Key.Power
[  588.792325] Mapping: Keyboard.0067 ---> Key.KPEqual
[  588.792331] Mapping: Keyboard.0068 ---> Key.F13
[  588.792339] Mapping: Keyboard.0069 ---> Key.F14
[  588.792346] Mapping: Keyboard.006a ---> Key.F15
[  588.792352] Mapping: Keyboard.006b ---> Key.F16
[  588.792359] Mapping: Keyboard.006c ---> Key.F17
[  588.792366] Mapping: Keyboard.006d ---> Key.F18
[  588.792372] Mapping: Keyboard.006e ---> Key.F19
[  588.792379] Mapping: Keyboard.006f ---> Key.F20
[  588.792385] Mapping: Keyboard.0070 ---> Key.F21
[  588.792392] Mapping: Keyboard.0071 ---> Key.F22
[  588.792422] Mapping: Keyboard.0072 ---> Key.F23
[  588.792429] Mapping: Keyboard.0073 ---> Key.F24
[  588.792436] Mapping: Keyboard.0074 ---> Key.Open
[  588.792442] Mapping: Keyboard.0075 ---> Key.Help
[  588.792449] Mapping: Keyboard.0076 ---> Key.Props
[  588.792457] Mapping: Keyboard.0077 ---> Key.Front
[  588.792463] Mapping: Keyboard.0078 ---> Key.Stop
[  588.792470] Mapping: Keyboard.0079 ---> Key.Again
[  588.792477] Mapping: Keyboard.007a ---> Key.Undo
[  588.792483] Mapping: Keyboard.007b ---> Key.Cut
[  588.792490] Mapping: Keyboard.007c ---> Key.Copy
[  588.792521] Mapping: Keyboard.007d ---> Key.Paste
[  588.792527] Mapping: Keyboard.007e ---> Key.Find
[  588.792535] Mapping: Keyboard.007f ---> Key.Mute
[  588.792541] Mapping: Keyboard.0080 ---> Key.VolumeUp
[  588.792548] Mapping: Keyboard.0081 ---> Key.VolumeDown
[  588.792555] Mapping: Keyboard.0082 ---> Key.Unknown
[  588.792563] Mapping: Keyboard.0083 ---> Key.Unknown
[  588.792570] Mapping: Keyboard.0084 ---> Key.Unknown
[  588.792577] Mapping: Keyboard.0085 ---> Key.KPComma
[  588.792584] Mapping: Keyboard.0086 ---> Key.Unknown
[  588.792590] Mapping: Keyboard.0087 ---> Key.RO
[  588.792620] Mapping: Keyboard.0088 ---> Key.Katakana/Hiragana
[  588.792628] Mapping: Keyboard.0089 ---> Key.Yen
[  588.792635] Mapping: Keyboard.008a ---> Key.Henkan
[  588.792642] Mapping: Keyboard.008b ---> Key.Muhenkan
[  588.792672] Mapping: Keyboard.008c ---> Key.KPJpComma
[  588.792701] Mapping: Keyboard.008d ---> Key.Unknown
[  588.792709] Mapping: Keyboard.008e ---> Key.Unknown
[  588.792715] Mapping: Keyboard.008f ---> Key.Unknown
[  588.792722] Mapping: Keyboard.0090 ---> Key.Hangeul
[  588.792729] Mapping: Keyboard.0091 ---> Key.Hanja
[  588.792736] Mapping: Keyboard.0092 ---> Key.Katakana
[  588.792743] Mapping: Keyboard.0093 ---> Key.HIRAGANA
[  588.792750] Mapping: Keyboard.0094 ---> Key.Zenkaku/Hankaku
[  588.792758] Mapping: Keyboard.0095 ---> Key.Unknown
[  588.792764] Mapping: Keyboard.0096 ---> Key.Unknown
[  588.792771] Mapping: Keyboard.0097 ---> Key.Unknown
[  588.792778] Mapping: Keyboard.0098 ---> Key.Unknown
[  588.792785] Mapping: Keyboard.0099 ---> Key.Unknown
[  588.792815] Mapping: Keyboard.009a ---> Key.Unknown
[  588.792822] Mapping: Keyboard.009b ---> Key.Unknown
[  588.792829] Mapping: Keyboard.009c ---> Key.Unknown
[  588.792836] Mapping: Keyboard.009d ---> Key.Unknown
[  588.792843] Mapping: Keyboard.009e ---> Key.Unknown
[  588.792850] Mapping: Keyboard.009f ---> Key.Unknown
[  588.792856] Mapping: Keyboard.00a0 ---> Key.Unknown
[  588.792887] Mapping: Keyboard.00a1 ---> Key.Unknown
[  588.792894] Mapping: Keyboard.00a2 ---> Key.Unknown
[  588.792900] Mapping: Keyboard.00a3 ---> Key.Unknown
[  588.792907] Mapping: Keyboard.00a4 ---> Key.Unknown
[  588.792914] Mapping: Keyboard.00a5 ---> Key.Unknown
[  588.792921] Mapping: Keyboard.00a6 ---> Key.Unknown
[  588.792928] Mapping: Keyboard.00a7 ---> Key.Unknown
[  588.792958] Mapping: Keyboard.00a8 ---> Key.Unknown
[  588.792964] Mapping: Keyboard.00a9 ---> Key.Unknown
[  588.792972] Mapping: Keyboard.00aa ---> Key.Unknown
[  588.792979] Mapping: Keyboard.00ab ---> Key.Unknown
[  588.792985] Mapping: Keyboard.00ac ---> Key.Unknown
[  588.792992] Mapping: Keyboard.00ad ---> Key.Unknown
[  588.792999] Mapping: Keyboard.00ae ---> Key.Unknown
[  588.793006] Mapping: Keyboard.00af ---> Key.Unknown
[  588.793059] Mapping: Keyboard.00b0 ---> Key.Unknown
[  588.793066] Mapping: Keyboard.00b1 ---> Key.Unknown
[  588.793073] Mapping: Keyboard.00b2 ---> Key.Unknown
[  588.793103] Mapping: Keyboard.00b3 ---> Key.Unknown
[  588.793110] Mapping: Keyboard.00b4 ---> Key.Unknown
[  588.793116] Mapping: Keyboard.00b5 ---> Key.Unknown
[  588.793123] Mapping: Keyboard.00b6 ---> Key.Unknown
[  588.793131] Mapping: Keyboard.00b7 ---> Key.Unknown
[  588.793138] Mapping: Keyboard.00b8 ---> Key.Unknown
[  588.793144] Mapping: Keyboard.00b9 ---> Key.Unknown
[  588.793151] Mapping: Keyboard.00ba ---> Key.Unknown
[  588.793157] Mapping: Keyboard.00bb ---> Key.Unknown
[  588.793165] Mapping: Keyboard.00bc ---> Key.Unknown
[  588.793172] Mapping: Keyboard.00bd ---> Key.Unknown
[  588.793179] Mapping: Keyboard.00be ---> Key.Unknown
[  588.793186] Mapping: Keyboard.00bf ---> Key.Unknown
[  588.793193] Mapping: Keyboard.00c0 ---> Key.Unknown
[  588.793200] Mapping: Keyboard.00c1 ---> Key.Unknown
[  588.793208] Mapping: Keyboard.00c2 ---> Key.Unknown
[  588.793215] Mapping: Keyboard.00c3 ---> Key.Unknown
[  588.793221] Mapping: Keyboard.00c4 ---> Key.Unknown
[  588.793252] Mapping: Keyboard.00c5 ---> Key.Unknown
[  588.793259] Mapping: Keyboard.00c6 ---> Key.Unknown
[  588.793266] Mapping: Keyboard.00c7 ---> Key.Unknown
[  588.793273] Mapping: Keyboard.00c8 ---> Key.Unknown
[  588.793280] Mapping: Keyboard.00c9 ---> Key.Unknown
[  588.793287] Mapping: Keyboard.00ca ---> Key.Unknown
[  588.793294] Mapping: Keyboard.00cb ---> Key.Unknown
[  588.793300] Mapping: Keyboard.00cc ---> Key.Unknown
[  588.793308] Mapping: Keyboard.00cd ---> Key.Unknown
[  588.793314] Mapping: Keyboard.00ce ---> Key.Unknown
[  588.793345] Mapping: Keyboard.00cf ---> Key.Unknown
[  588.793351] Mapping: Keyboard.00d0 ---> Key.Unknown
[  588.793358] Mapping: Keyboard.00d1 ---> Key.Unknown
[  588.793389] Mapping: Keyboard.00d2 ---> Key.Unknown
[  588.793419] Mapping: Keyboard.00d3 ---> Key.Unknown
[  588.793449] Mapping: Keyboard.00d4 ---> Key.Unknown
[  588.793456] Mapping: Keyboard.00d5 ---> Key.Unknown
[  588.793463] Mapping: Keyboard.00d6 ---> Key.Unknown
[  588.793493] Mapping: Keyboard.00d7 ---> Key.Unknown
[  588.793500] Mapping: Keyboard.00d8 ---> Key.Unknown
[  588.793507] Mapping: Keyboard.00d9 ---> Key.Unknown
[  588.793514] Mapping: Keyboard.00da ---> Key.Unknown
[  588.793544] Mapping: Keyboard.00db ---> Key.Unknown
[  588.793551] Mapping: Keyboard.00dc ---> Key.Unknown
[  588.793558] Mapping: Keyboard.00dd ---> Key.Unknown
[  588.793587] Mapping: Keyboard.00de ---> Key.Unknown
[  588.793594] Mapping: Keyboard.00df ---> Key.Unknown
[  588.793601] Mapping: Keyboard.00e0 ---> Key.LeftControl
[  588.793608] Mapping: Keyboard.00e1 ---> Key.LeftShift
[  588.793614] Mapping: Keyboard.00e2 ---> Key.LeftAlt
[  588.793622] Mapping: Keyboard.00e3 ---> Key.LeftMeta
[  588.793629] Mapping: Keyboard.00e4 ---> Key.RightCtrl
[  588.793635] Mapping: Keyboard.00e5 ---> Key.RightShift
[  588.793642] Mapping: Keyboard.00e6 ---> Key.RightAlt
[  588.793648] Mapping: Keyboard.00e7 ---> Key.RightMeta
[  588.793655] Mapping: Keyboard.00e8 ---> Key.PlayPause
[  588.793708] Mapping: Keyboard.00e9 ---> Key.StopCD
[  588.793715] Mapping: Keyboard.00ea ---> Key.PreviousSong
[  588.793727] Mapping: Keyboard.00eb ---> Key.NextSong
[  588.793736] Mapping: Keyboard.00ec ---> Key.EjectCD
[  588.793743] Mapping: Keyboard.00ed ---> Key.VolumeUp
[  588.793750] Mapping: Keyboard.00ee ---> Key.VolumeDown
[  588.793757] Mapping: Keyboard.00ef ---> Key.Mute
[  588.793764] Mapping: Keyboard.00f0 ---> Key.WWW
[  588.793771] Mapping: Keyboard.00f1 ---> Key.Back
[  588.793778] Mapping: Keyboard.00f2 ---> Key.Forward
[  588.793785] Mapping: Keyboard.00f3 ---> Key.Stop
[  588.793791] Mapping: Keyboard.00f4 ---> Key.Find
[  588.793799] Mapping: Keyboard.00f5 ---> Key.ScrollUp
[  588.793806] Mapping: Keyboard.00f6 ---> Key.ScrollDown
[  588.793813] Mapping: Keyboard.00f7 ---> Key.Edit
[  588.793820] Mapping: Keyboard.00f8 ---> Key.Sleep
[  588.793828] Mapping: Keyboard.00f9 ---> Key.Coffee
[  588.793834] Mapping: Keyboard.00fa ---> Key.Refresh
[  588.793842] Mapping: Keyboard.00fb ---> Key.Calc
[  588.793848] Mapping: Keyboard.00fc ---> Key.Unknown
[  588.793856] Mapping: Keyboard.00fd ---> Key.Unknown
[  588.793863] Mapping: Keyboard.00fe ---> Key.Unknown
[  588.793892] Mapping: Keyboard.00ff ---> Key.Unknown
[  588.793900] Mapping: ffbc.0000 ---> IGNORED
[  588.793907] Mapping: ffbc.0001 ---> IGNORED
[  588.793913] Mapping: ffbc.0002 ---> IGNORED
[  588.793921] Mapping: ffbc.0003 ---> IGNORED
[  588.793927] Mapping: ffbc.0004 ---> Key.Again
[  588.793935] Mapping: ffbc.0005 ---> IGNORED
[  588.793965] Mapping: ffbc.0006 ---> IGNORED
[  588.793972] Mapping: ffbc.0007 ---> IGNORED
[  588.793979] Mapping: ffbc.0008 ---> IGNORED
[  588.793986] Mapping: ffbc.0009 ---> IGNORED
[  588.793993] Mapping: ffbc.000a ---> IGNORED
[  588.794022] Mapping: ffbc.000b ---> IGNORED
[  588.794030] Mapping: ffbc.000c ---> IGNORED
[  588.794037] Mapping: ffbc.000d ---> Key.Home
[  588.794045] Mapping: ffbc.000e ---> IGNORED
[  588.794075] Mapping: ffbc.000f ---> IGNORED
[  588.794105] Mapping: ffbc.0010 ---> IGNORED
[  588.794111] Mapping: ffbc.0011 ---> IGNORED
[  588.794119] Mapping: ffbc.0012 ---> IGNORED
[  588.794125] Mapping: ffbc.0013 ---> IGNORED
[  588.794132] Mapping: ffbc.0014 ---> IGNORED
[  588.794140] Mapping: ffbc.0015 ---> IGNORED
[  588.794147] Mapping: ffbc.0016 ---> IGNORED
[  588.794154] Mapping: ffbc.0017 ---> IGNORED
[  588.794161] Mapping: ffbc.0018 ---> IGNORED
[  588.794168] Mapping: ffbc.0019 ---> IGNORED
[  588.794175] Mapping: ffbc.001a ---> IGNORED
[  588.794182] Mapping: ffbc.001b ---> IGNORED
[  588.794188] Mapping: ffbc.001c ---> IGNORED
[  588.794195] Mapping: ffbc.001d ---> IGNORED
[  588.794202] Mapping: ffbc.001e ---> IGNORED
[  588.794232] Mapping: ffbc.001f ---> IGNORED
[  588.794239] Mapping: ffbc.0020 ---> IGNORED
[  588.794246] Mapping: ffbc.0021 ---> IGNORED
[  588.794254] Mapping: ffbc.0022 ---> IGNORED
[  588.794260] Mapping: ffbc.0023 ---> IGNORED
[  588.794268] Mapping: ffbc.0024 ---> Key.Shuffle
[  588.794276] Mapping: ffbc.0025 ---> Key.TV
[  588.794283] Mapping: ffbc.0026 ---> Key.Menu
[  588.794314] Mapping: ffbc.0027 ---> IGNORED
[  588.794321] Mapping: ffbc.0028 ---> IGNORED
[  588.794328] Mapping: ffbc.0029 ---> IGNORED
[  588.794335] Mapping: ffbc.002a ---> IGNORED
[  588.794342] Mapping: ffbc.002b ---> IGNORED
[  588.794371] Mapping: ffbc.002c ---> IGNORED
[  588.794379] Mapping: ffbc.002d ---> IGNORED
[  588.794385] Mapping: ffbc.002e ---> IGNORED
[  588.794415] Mapping: ffbc.002f ---> IGNORED
[  588.794422] Mapping: ffbc.0030 ---> IGNORED
[  588.794452] Mapping: ffbc.0031 ---> Key.Audio
[  588.794482] Mapping: ffbc.0032 ---> Key.Text
[  588.794490] Mapping: ffbc.0033 ---> Key.Last
[  588.794498] Mapping: ffbc.0034 ---> IGNORED
[  588.794528] Mapping: ffbc.0035 ---> IGNORED
[  588.794535] Mapping: ffbc.0036 ---> IGNORED
[  588.794542] Mapping: ffbc.0037 ---> IGNORED
[  588.794549] Mapping: ffbc.0038 ---> IGNORED
[  588.794556] Mapping: ffbc.0039 ---> IGNORED
[  588.794563] Mapping: ffbc.003a ---> IGNORED
[  588.794570] Mapping: ffbc.003b ---> IGNORED
[  588.794577] Mapping: ffbc.003c ---> IGNORED
[  588.794584] Mapping: ffbc.003d ---> IGNORED
[  588.794591] Mapping: ffbc.003e ---> IGNORED
[  588.794598] Mapping: ffbc.003f ---> IGNORED
[  588.794605] Mapping: ffbc.0040 ---> IGNORED
[  588.794612] Mapping: ffbc.0041 ---> IGNORED
[  588.794619] Mapping: ffbc.0042 ---> IGNORED
[  588.794626] Mapping: ffbc.0043 ---> IGNORED
[  588.794633] Mapping: ffbc.0044 ---> IGNORED
[  588.794640] Mapping: ffbc.0045 ---> IGNORED
[  588.794647] Mapping: ffbc.0046 ---> IGNORED
[  588.794654] Mapping: ffbc.0047 ---> Key.MP3
[  588.794662] Mapping: ffbc.0048 ---> Key.DVD
[  588.794692] Mapping: ffbc.0049 ---> Key.Media
[  588.794700] Mapping: ffbc.004a ---> Key.Video
[  588.794707] Mapping: ffbc.004b ---> Key.Angle
[  588.794716] Mapping: ffbc.004c ---> Key.Language
[  588.794724] Mapping: ffbc.004d ---> Key.Subtitle
[  588.794732] Mapping: ffbc.004e ---> IGNORED
[  588.794739] Mapping: ffbc.004f ---> IGNORED
[  588.794746] Mapping: ffbc.0050 ---> IGNORED
[  588.794753] Mapping: ffbc.0051 ---> Key.Red
[  588.794760] Mapping: ffbc.0052 ---> Key.Close
[  588.794769] Mapping: ffbc.0053 ---> IGNORED
[  588.794776] Mapping: ffbc.0054 ---> IGNORED
[  588.794783] Mapping: ffbc.0055 ---> IGNORED
[  588.794791] Mapping: ffbc.0056 ---> IGNORED
[  588.794798] Mapping: ffbc.0057 ---> IGNORED
[  588.794829] Mapping: ffbc.0058 ---> IGNORED
[  588.794837] Mapping: ffbc.0059 ---> IGNORED
[  588.794844] Mapping: ffbc.005a ---> Key.Text
[  588.794853] Mapping: ffbc.005b ---> IGNORED
[  588.794860] Mapping: ffbc.005c ---> IGNORED
[  588.794867] Mapping: ffbc.005d ---> IGNORED
[  588.794874] Mapping: ffbc.005e ---> IGNORED
[  588.794882] Mapping: ffbc.005f ---> IGNORED
[  588.794890] Mapping: ffbc.0060 ---> IGNORED
[  588.794897] Mapping: ffbc.0061 ---> IGNORED
[  588.794905] Mapping: ffbc.0062 ---> IGNORED
[  588.794913] Mapping: ffbc.0063 ---> IGNORED
[  588.794920] Mapping: ffbc.0064 ---> IGNORED
[  588.794928] Mapping: ffbc.0065 ---> IGNORED
[  588.794935] Mapping: ffbc.0066 ---> IGNORED
[  588.794943] Mapping: ffbc.0067 ---> IGNORED
[  588.794950] Mapping: ffbc.0068 ---> IGNORED
[  588.794957] Mapping: ffbc.0069 ---> IGNORED
[  588.794965] Mapping: ffbc.006a ---> IGNORED
[  588.794972] Mapping: ffbc.006b ---> IGNORED
[  588.794979] Mapping: ffbc.006c ---> IGNORED
[  588.794987] Mapping: ffbc.006d ---> IGNORED
[  588.794994] Mapping: ffbc.006e ---> IGNORED
[  588.795025] Mapping: ffbc.006f ---> IGNORED
[  588.795032] Mapping: ffbc.0070 ---> IGNORED
[  588.795040] Mapping: ffbc.0071 ---> IGNORED
[  588.795048] Mapping: ffbc.0072 ---> IGNORED
[  588.795055] Mapping: ffbc.0073 ---> IGNORED
[  588.795062] Mapping: ffbc.0074 ---> IGNORED
[  588.795069] Mapping: ffbc.0075 ---> IGNORED
[  588.795077] Mapping: ffbc.0076 ---> IGNORED
[  588.795085] Mapping: ffbc.0077 ---> IGNORED
[  588.795092] Mapping: ffbc.0078 ---> IGNORED
[  588.795100] Mapping: ffbc.0079 ---> IGNORED
[  588.795108] Mapping: ffbc.007a ---> IGNORED
[  588.795115] Mapping: ffbc.007b ---> IGNORED
[  588.795122] Mapping: ffbc.007c ---> IGNORED
[  588.795130] Mapping: ffbc.007d ---> IGNORED
[  588.795137] Mapping: ffbc.007e ---> IGNORED
[  588.795145] Mapping: ffbc.007f ---> IGNORED
[  588.795152] Mapping: ffbc.0080 ---> IGNORED
[  588.795159] Mapping: ffbc.0081 ---> IGNORED
[  588.795167] Mapping: ffbc.0082 ---> IGNORED
[  588.795174] Mapping: ffbc.0083 ---> IGNORED
[  588.795182] Mapping: ffbc.0084 ---> IGNORED
[  588.795189] Mapping: ffbc.0085 ---> IGNORED
[  588.795197] Mapping: ffbc.0086 ---> IGNORED
[  588.795204] Mapping: ffbc.0087 ---> IGNORED
[  588.795211] Mapping: ffbc.0088 ---> IGNORED
[  588.795219] Mapping: ffbc.0089 ---> IGNORED
[  588.795227] Mapping: ffbc.008a ---> IGNORED
[  588.795234] Mapping: ffbc.008b ---> IGNORED
[  588.795241] Mapping: ffbc.008c ---> IGNORED
[  588.795249] Mapping: ffbc.008d ---> IGNORED
[  588.795280] Mapping: ffbc.008e ---> IGNORED
[  588.795287] Mapping: ffbc.008f ---> IGNORED
[  588.795295] Mapping: ffbc.0090 ---> IGNORED
[  588.795302] Mapping: ffbc.0091 ---> IGNORED
[  588.795310] Mapping: ffbc.0092 ---> IGNORED
[  588.795318] Mapping: ffbc.0093 ---> IGNORED
[  588.795326] Mapping: ffbc.0094 ---> IGNORED
[  588.795333] Mapping: ffbc.0095 ---> IGNORED
[  588.795339] Mapping: ffbc.0096 ---> IGNORED
[  588.795347] Mapping: ffbc.0097 ---> IGNORED
[  588.795354] Mapping: ffbc.0098 ---> IGNORED
[  588.795361] Mapping: ffbc.0099 ---> IGNORED
[  588.795369] Mapping: ffbc.009a ---> IGNORED
[  588.795377] Mapping: ffbc.009b ---> IGNORED
[  588.795384] Mapping: ffbc.009c ---> IGNORED
[  588.795391] Mapping: ffbc.009d ---> IGNORED
[  588.795399] Mapping: ffbc.009e ---> IGNORED
[  588.795407] Mapping: ffbc.009f ---> IGNORED
[  588.795415] Mapping: ffbc.00a0 ---> IGNORED
[  588.795422] Mapping: ffbc.00a1 ---> IGNORED
[  588.795430] Mapping: ffbc.00a2 ---> IGNORED
[  588.795437] Mapping: ffbc.00a3 ---> IGNORED
[  588.795444] Mapping: ffbc.00a4 ---> IGNORED
[  588.795452] Mapping: ffbc.00a5 ---> IGNORED
[  588.795458] Mapping: ffbc.00a6 ---> IGNORED
[  588.795465] Mapping: ffbc.00a7 ---> IGNORED
[  588.795471] Mapping: ffbc.00a8 ---> IGNORED
[  588.795478] Mapping: ffbc.00a9 ---> IGNORED
[  588.795508] Mapping: ffbc.00aa ---> IGNORED
[  588.795516] Mapping: ffbc.00ab ---> IGNORED
[  588.795546] Mapping: ffbc.00ac ---> IGNORED
[  588.795554] Mapping: ffbc.00ad ---> IGNORED
[  588.795561] Mapping: ffbc.00ae ---> IGNORED
[  588.795569] Mapping: ffbc.00af ---> IGNORED
[  588.795575] Mapping: ffbc.00b0 ---> IGNORED
[  588.795582] Mapping: ffbc.00b1 ---> IGNORED
[  588.795588] Mapping: ffbc.00b2 ---> IGNORED
[  588.795595] Mapping: ffbc.00b3 ---> IGNORED
[  588.795625] Mapping: ffbc.00b4 ---> IGNORED
[  588.795656] Mapping: ffbc.00b5 ---> IGNORED
[  588.795664] Mapping: ffbc.00b6 ---> IGNORED
[  588.795671] Mapping: ffbc.00b7 ---> IGNORED
[  588.795679] Mapping: ffbc.00b8 ---> IGNORED
[  588.795686] Mapping: ffbc.00b9 ---> IGNORED
[  588.795694] Mapping: ffbc.00ba ---> IGNORED
[  588.795702] Mapping: ffbc.00bb ---> IGNORED
[  588.795709] Mapping: ffbc.00bc ---> IGNORED
[  588.795716] Mapping: ffbc.00bd ---> IGNORED
[  588.795724] Mapping: ffbc.00be ---> IGNORED
[  588.795731] Mapping: ffbc.00bf ---> IGNORED
[  588.795739] Mapping: ffbc.00c0 ---> IGNORED
[  588.795746] Mapping: ffbc.00c1 ---> IGNORED
[  588.795754] Mapping: ffbc.00c2 ---> IGNORED
[  588.795762] Mapping: ffbc.00c3 ---> IGNORED
[  588.795769] Mapping: ffbc.00c4 ---> IGNORED
[  588.795777] Mapping: ffbc.00c5 ---> IGNORED
[  588.795785] Mapping: ffbc.00c6 ---> IGNORED
[  588.795792] Mapping: ffbc.00c7 ---> IGNORED
[  588.795800] Mapping: ffbc.00c8 ---> IGNORED
[  588.795807] Mapping: ffbc.00c9 ---> IGNORED
[  588.795838] Mapping: ffbc.00ca ---> IGNORED
[  588.795846] Mapping: ffbc.00cb ---> IGNORED
[  588.795854] Mapping: ffbc.00cc ---> IGNORED
[  588.795862] Mapping: ffbc.00cd ---> IGNORED
[  588.795869] Mapping: ffbc.00ce ---> IGNORED
[  588.795876] Mapping: ffbc.00cf ---> IGNORED
[  588.795884] Mapping: ffbc.00d0 ---> IGNORED
[  588.795891] Mapping: ffbc.00d1 ---> IGNORED
[  588.795898] Mapping: ffbc.00d2 ---> IGNORED
[  588.795906] Mapping: ffbc.00d3 ---> IGNORED
[  588.795913] Mapping: ffbc.00d4 ---> IGNORED
[  588.795943] Mapping: ffbc.00d5 ---> IGNORED
[  588.795951] Mapping: ffbc.00d6 ---> IGNORED
[  588.795959] Mapping: ffbc.00d7 ---> IGNORED
[  588.795966] Mapping: ffbc.00d8 ---> IGNORED
[  588.795974] Mapping: ffbc.00d9 ---> IGNORED
[  588.795981] Mapping: ffbc.00da ---> IGNORED
[  588.795988] Mapping: ffbc.00db ---> IGNORED
[  588.795995] Mapping: ffbc.00dc ---> IGNORED
[  588.796002] Mapping: ffbc.00dd ---> IGNORED
[  588.796009] Mapping: ffbc.00de ---> IGNORED
[  588.796016] Mapping: ffbc.00df ---> IGNORED
[  588.796024] Mapping: ffbc.00e0 ---> IGNORED
[  588.796031] Mapping: ffbc.00e1 ---> IGNORED
[  588.796038] Mapping: ffbc.00e2 ---> IGNORED
[  588.796067] Mapping: ffbc.00e3 ---> IGNORED
[  588.796075] Mapping: ffbc.00e4 ---> IGNORED
[  588.796083] Mapping: ffbc.00e5 ---> IGNORED
[  588.796090] Mapping: ffbc.00e6 ---> IGNORED
[  588.796097] Mapping: ffbc.00e7 ---> IGNORED
[  588.796104] Mapping: ffbc.00e8 ---> IGNORED
[  588.796111] Mapping: ffbc.00e9 ---> IGNORED
[  588.796118] Mapping: ffbc.00ea ---> IGNORED
[  588.796125] Mapping: ffbc.00eb ---> IGNORED
[  588.796132] Mapping: ffbc.00ec ---> IGNORED
[  588.796140] Mapping: ffbc.00ed ---> IGNORED
[  588.796146] Mapping: ffbc.00ee ---> IGNORED
[  588.796154] Mapping: ffbc.00ef ---> IGNORED
[  588.796161] Mapping: ffbc.00f0 ---> IGNORED
[  588.796169] Mapping: ff80.0001 ---> Absolute.Misc
[  588.796201] Mapping: ff80.0001 ---> Absolute.?
[  588.796209] Mapping: ff80.0001 ---> Absolute.?
[  588.796217] Mapping: ff80.0001 ---> Absolute.?
[  588.796225] Mapping: LED.NumLock ---> LED.NumLock
[  588.796233] Mapping: LED.CapsLock ---> LED.CapsLock
[  588.796240] Mapping: LED.ScrollLock ---> LED.ScrollLock
[  588.796246] Mapping: LED.Compose ---> LED.Compose
[  588.796253] Mapping: LED.Kana ---> LED.Kana
[  588.796260] Mapping: ff80.0002 ---> Absolute.?
[  588.796269] Mapping: ff80.0002 ---> Absolute.?
[  588.796277] Mapping: ff80.0002 ---> Absolute.?
[  588.796285] Mapping: ff80.0002 ---> Absolute.?
[  588.796293] Mapping: ff80.0002 ---> Absolute.?
[  588.796302] Mapping: ff80.0002 ---> Absolute.?
[  588.796310] Mapping: ff80.0002 ---> Absolute.?
[  588.796440] input: ELMAK.pl irMAKbd pl as /class/input/input8
[  588.796566] PM: Adding info for No Bus:hiddev0
[  588.796591] input,hiddev96: USB HID v1.00 Mouse [ELMAK.pl irMAKbd pl] on usb-0000:00:03.0-3
[  588.796656] PM: Adding info for No Bus:usbdev1.4_ep81
[  588.796692] PM: Adding info for No Bus:usbdev1.4_ep02
[  588.796734] PM: Adding info for No Bus:usbdev1.4
[  588.801745] drivers/hid/hid-core.c: report (size 5) (numbered)
[  588.801750] drivers/hid/hid-core.c: report 6 (size 4) =  ab 40 04 00
[  588.801760] hid-debug: input ff80.0001 = 171
[  588.801781] hid-debug: input ff80.0001 = 64
[  588.801789] hid-debug: input ff80.0001 = 4
[  588.801796] hid-debug: input ff80.0001 = 0
[  589.124161] tsdev (compaq touchscreen emulation) is scheduled for removal.
[  589.124166] See Documentation/feature-removal-schedule.txt for details.

--=-kT/p/foOM/D40VsWIl5Y--

