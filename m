Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbYJXKex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbYJXKex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 06:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbYJXKep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 06:34:45 -0400
Received: from bene1.itea.ntnu.no ([129.241.56.56]:37895 "EHLO
	bene1.itea.ntnu.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbYJXKeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 06:34:44 -0400
X-Greylist: delayed 1246 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Oct 2008 06:34:44 EDT
Message-ID: <4901A4C2.5020805@free.fr>
Date: Fri, 24 Oct 2008 12:34:42 +0200
From: Mathieu Taillefumier <mathieu.taillefumier@free.fr>
User-Agent: Thunderbird/3.0a2 (X11; 2008091114)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [Bug] pci allocation resources problems on x86_64
References: <49019FE4.50001@free.fr>
In-Reply-To: <49019FE4.50001@free.fr>
Content-Type: multipart/mixed;
 boundary="------------050706070009050503060402"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050706070009050503060402
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi

Sorry, the first files iomem and ioports are not the right one (I used 
the mem option to check if it has any effects). Please find the right 
one in attachments. Sorry again for this mistake.

regards

Mathieu
> Hi,
>
> The kernel does not seems to allocate the pci resources correctly on 
> sony laptop (VGN-SZ71 series) when pcmcia slot is used.
>
> I track down this bug for long now and I was able to identify where it 
> is probably coming from. The laptop I am using possess a pcmcia card 
> slot  that I am using for a tvcard. The kernel is a x86_64 bits kernel 
> (2.6.27.2) and the laptop has 4G of memory. In this case the 
> initialization of the tv-card is pure garbage and the kernel oops 
> after that. Now if I start the laptop with 2G and the same kernel then 
> everything works fine. From that I can assume that the problem does 
> not come from the tvcard driver and maybe not from the pcmcia driver 
> (although I am not completely sure). After discussing on the dvb 
> mailling list we arrive to the conclusion that the problem is probably 
> coming from pci allocation ressources.
>
> additional informations :
>
> Configurations that work
>
> - x86_64 kernels with 2G of memory
> - x86 kernels with 4G of memory without PAE activated nor 64 bits 
> resources allocations option activated.
>
> Config that do not work
>
> - x86_64 kernels with 4G of memory
> - x86 kernels with 4G of memory with 64bits resources allocation 
> activated (without PAE).
>
> The problem can be reproduced with kernel-next and the kernel-git so 
> far and probably with earlier kernels although I have try this
>
> cat /proc/version
> Linux version 2.6.27.2-intel-nogem (root@coesite) (gcc version 4.3.1 
> (GCC) ) #4 SMP Wed Oct 22 12:05:55 CEST 2008
> the lspci output are in one of the files and different dmesg are 
> included. the dmesg-diff give the differences between the working one 
> and the buggy one.
>
> I would like to help debugging this
>
> Regards
>
> Mathieu


--------------050706070009050503060402
Content-Type: application/gzip;
 name="iomem.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="iomem.gz"

H4sICFmkAUkAA2lvbWVtAH2V226jMBRF3/kK/0AjDOaWtwwznaCZtNG075Vj+7RRaZAC6TR/
P8bmcAlmokSy2It99vEtvm8/d/qXQQJA1uTpWjfqg/zZ7DzzNEUZjHxWtTp/KtmKCt+FuUit
8QFi0YkjY0J8P8DKEQ1SSTXwS51PqiSiksoQRgg0EacQ0mQgJG+4IeI2XeuRZEmcjohDXXu6
tMQMUtkMm3xfkIfqdPdZlbw5loo8NdWZvypDg6Vh1o4IunmyAyO2g7X+UliFBqAIUPt2cWp0
kvvyUr+RfVtCMHRJ+hL7vCDfLnXnlumulqicn+VAck+kyGULbqknBDJykZG4B+TQOPbmByvf
UwgomJjsdvnjw33xk/g6tQvqpw9QBLoQI/AApxjCBSb2AKcGogUm0VEGipmlGBpKdE+6IYgR
WFoHHQdnF5ZmN25L9VTaL3un2lKEuKHj35K/njzgKB3+11BP6UHoaMhUcUD1+1V3gntAD5zr
C4IiQB0A1UCAQLC8b8fUNGW29pm2sQhDhM2QrhEHdFWnhr/UlXhXTecTIRLNfILe5xZqjvDx
knx9YZgY9Thx5XVD1Zs40jBjel4i7DiadqxvhYNpx4UU+ZZsvxN+kcfKeDAEWDj14KvEAgyB
ZArIFlCiK6HsAo9Pnk4wlv0uweNmX+T63IKSKEqza7S43f94NkfaJQ5HWknKOpFmt+ddPxOd
mM4uA6XQVmGg35XgJWlDmbpzYHgbcDc77hm7j1uVhoM8+t+hrAfY9Jq5vV3/ARVGwpYaBwAA

--------------050706070009050503060402
Content-Type: application/gzip;
 name="ioports.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="ioports.gz"

H4sICFykAUkAA2lvcG9ydHMAdZXNjpswGEX3PIX3VVrbEHBm10lHVdROi9ppt5ExOEEzSRAh
o+bt+93AYENdKfLinuOLf0DhnPMF58KyO1YetIg4lwikoKCpDYIEQRJT0NWHquUULREtxwhW
iijlFD1X1+Kk2xJhgjCZhhnMLKOw7QzaFAI1LIE1elexttoR0AB6WIqkwCAoBxOBRWAR2OYS
cYFuceumjfE7+gn7XkSM+Uh3etvU9R/yMV/YoO+Q8+MsXWAI+B7yfCw4vi34daffUWBh2WCB
Q64gxdmkKxQ0x4ZhRhbRgVGq+Cw1Vi1oQJqvN8ycjlZEAhcseGanT+T0RB+5GsZGwnHBH9f5
huWPQm8ffj9t779+eTMSGMuJsf42MRSMwhnbp8cfAxPoF+Psdf6Ldfv21HUv1WBIGJK72XJW
L1Ev7ZvwOX/gNyoEnZkQRWjHHnI7Fim94TTMUhwyDf67wSXVCIXFK2H/vUMfjXcoFLai4omv
+/V46LI39XZvSvKxHLWc+X2/Q56fIpzecDn0O+T5OAS1mvl9v0OerxEWM1/efIc8v0RYzs6n
9x3yzqdCWAV9hzzfIrRxyHfI9xOEWdAfke8rhMH1OOR8gxfF8FC/hzwfl27iWX988x2qFRfb
86G4nCOJz1Ha8cu+v5yHmTKKweIQS6MELAkxfOY95d4+M1rK7b2ZwvPzVUZLBMtQl4pSsDTE
VlTWUz7SNf0LOEPDSGAk/zUMGkz/J/XzdLyyvD3tWn3QxUvFNh++s0/Va22qyFbkYZh8yH8B
jiqs3eMGAAA=
--------------050706070009050503060402--
