Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbZEXQLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbZEXQLb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 12:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbZEXQLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 12:11:21 -0400
Received: from smtpout2.uol.com.br ([200.221.4.193]:56983 "EHLO
	smtp.uol.com.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752991AbZEXQLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 12:11:20 -0400
Date: Sun, 24 May 2009 13:11:14 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [2.6.30-rc2] usb reset during big file transfer and ext3 error
Message-ID: <20090524161114.GA2667@ime.usp.br>
References: <20090524071637.GA5487@ime.usp.br> <Pine.LNX.4.44L0.0905241035380.7718-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.0905241035380.7718-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SIG5: b3d963257f5053c5c708b44088d167c8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On May 24 2009, Alan Stern wrote:
> It is abnormal, but I can't tell what the reason is without more
> information.  You should try using usbmon (see
> Documentation/usb/usbmon.txt) to trace these events.

Here you go with a log that is pure text (compressed). The part of dmesg
relative to the USB plugging is here:

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
[  248.286615] usb-storage: device found at 3
[  248.286620] usb-storage: waiting for device to settle before scanning
[  248.286631] usbcore: registered new interface driver usb-storage
[  248.286636] USB Mass Storage support registered.
[  248.351740] usb 4-2.2: New USB device found, idVendor=067b, idProduct=2316
[  248.351749] usb 4-2.2: New USB device strings: Mfr=1, Product=5, SerialNumber=0
[  248.351753] usb 4-2.2: Product: USB Security Device
[  248.351756] usb 4-2.2: Manufacturer: Leading Driver Co.,LTD.
[  248.351860] PM: Adding info for usb:4-2.2
[  248.351907] usb 4-2.2: configuration #1 chosen from 1 choice
[  248.354759] PM: Adding info for usb:4-2.2:1.0
[  248.354894] PM: Adding info for No Bus:usbdev4.4_ep00
[  253.288125] usb-storage: device scan complete
[  253.291081] scsi 0:0:0:0: Direct-Access     Prolific USB Flash Disk   1.00 PQ: 0 ANSI: 0 CCS
[  253.291476] PM: Adding info for scsi:target0:0:0
[  253.291903] PM: Adding info for scsi:0:0:0:0
[  253.292167] PM: Adding info for No Bus:0:0:0:0
[  253.331140] Driver 'sd' needs updating - please use bus_type methods
[  253.331290] PM: Adding info for No Bus:0:0:0:0
[  253.337069] sd 0:0:0:0: [sda] 256000 512-byte hardware sectors: (131 MB/125 MiB)
[  253.340068] sd 0:0:0:0: [sda] Write Protect is off
[  253.340073] sd 0:0:0:0: [sda] Mode Sense: 23 00 00 00
[  253.340077] sd 0:0:0:0: [sda] Assuming drive cache: write through
[  253.340130] PM: Adding info for No Bus:sda
[  253.347047] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[  253.347053]    : Sense Key : 0x0 [current] 
[  253.347059]    : ASC=0x0 ASCQ=0x0
[  253.355049] sd 0:0:0:0: [sda] Assuming drive cache: write through
[  253.355057]  sda: sda1
[  253.361106] PM: Adding info for No Bus:sda1
[  253.366054] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[  253.366060]    : Sense Key : 0x0 [current] 
[  253.366066]    : ASC=0x0 ASCQ=0x0
[  253.366162] PM: Adding info for No Bus:8:0
[  253.366196] sd 0:0:0:0: [sda] Attached SCSI removable disk
[  253.386056] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[  253.386063]    : Sense Key : 0x0 [current] 
[  253.386069]    : ASC=0x0 ASCQ=0x0
[  253.690947] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[  253.690954]    : Sense Key : 0x0 [current] 
[  253.690960]    : ASC=0x0 ASCQ=0x0
[  253.784900] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[  253.784909]    : Sense Key : 0x0 [current] 
[  253.784916]    : ASC=0x0 ASCQ=0x0
[  253.806909] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[  253.806914]    : Sense Key : 0x0 [current] 
[  253.806919]    : ASC=0x0 ASCQ=0x0
[  253.816898] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[  253.816904]    : Sense Key : 0x0 [current] 
[  253.816910]    : ASC=0x0 ASCQ=0x0
[  254.118799] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[  254.118806]    : Sense Key : 0x0 [current] 
[  254.118812]    : ASC=0x0 ASCQ=0x0
[  254.128798] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[  254.128804]    : Sense Key : 0x0 [current] 
[  254.128810]    : ASC=0x0 ASCQ=0x0
[  254.432691] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[  254.432697]    : Sense Key : 0x0 [current] 
[  254.432703]    : ASC=0x0 ASCQ=0x0
[  254.495644] sd 0:0:0:0: ioctl_internal_command return code = 8000002
[  254.495650]    : Sense Key : 0x0 [current] 
[  254.495656]    : ASC=0x0 ASCQ=0x0
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

If you need further information, please let me know.


Thanks,

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org

--SLDf9lqlvOQaIe6s
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="1.mon.out.bz2"
Content-Transfer-Encoding: base64

QlpoOTFBWSZTWR2meRQA7iZfgHwQQAJ/9xggCAA/IIgAYEhe+8AB8AAA6nExttkpNgA2pG+A
AGQAA+zqtj3yKJm1rPd75xPsOoBegHuzL207TRu3F7vZXjxU7NlZY92rnnuPehgdsSjs29eA
8e2ddI6ax3XgLG5989XPqvpgWxlDa3HreqJeZ169TeN52q92XVgMXhj3MPMZF7btz1528b3g
Oym7iFt1icjaYLTRuieeRtgcG3TI22qptqHwlACCIiQoAjA1PTEFJUU2SNQAART89VTSnlNl
IQAaYgJT0iRkSJoigDQAiSAmhIQiho0GgVFEExBpIKIBobQVPn/lB3+Fgsv18/LDlIjeD+SY
yKrCZNLEkRMFiBbIkEilk/b4kkkk/aySSSZZJFnxLLuJZfzG4Pd8NNCWXgew09ns00DTTTgB
6H6DsehLL0PuOR0P8AdDofYdDkAAePTxpoGmmnA4cOGmgaaacDseDsdiWXoehyOh4A6HQ8HQ
5AAHj08aaBpppwOx4Ox2JZeh6HI6HgDodDwdDkAAB49PGmgaaacAMtoAABuJZeBocD4HQ6Ho
ehLLyOB4PcfYaHuA4AB2AANxwPkNDsdiWXsdjofIByOR2OR7gAAAXd3d38sxVVwfYQvIRVkI
qqqqqqqqqqqqqrIqkkUiyKqqRVVVVZCKqqqqqqqqsiqRVVVVZCKqyKqqqkVVVZCKqqqqqqqq
qqqqqqqqqqqqqqqyKpFVVWQiqqqqqqqqqqqqqsiqRVVVV3cVVVVVVUtVVVXIRbiqqkVZFVVU
kiqqqqqRVVqx1CCDGP9v7bWlpRP3Jx7VVVVVVVVVVVVW4TcIqyHG1W4SQ/jaqqrcVVVVVVVV
Ve+piqqqqyeP0+K4nj0u4RZFIq3l2qquRVVVVVIqqqqm3Kf7YptYqqxiqq7tiqrGKqqvSr3C
KsikXCRVVVk7VVVlMS1VVWyRciqqqtig8Yr0xXqVq1OlkUkhJFVVrMhIpOpNKr4y41SRVfGd
wmRbVVS+8HMVVVVVTFvhVCmxVCCADFGEz/L1ISSSSSSQVRpFUVFQVVVADKAKGqaSQC4qhTRF
WCIJAgowP8ZeoEiCBaR/oR/0NlMmnZKkkr5KJJVNm2k96feBvUWrYTTyw67Zkg6hNKkkOZF4
5NXKUNO9f8SNE0HhSLTzRipLQkWyRbBaRbE6RrZJIpIrIjILILIrIrILSkQYJiJndjodU+2K
sTKVElFhqm9irEukhZUlZZLOs1Rooc0WBICNhkrCmpDX+XvfSnaNVVFB/pVH6hjvcLY3IskW
SLJFklFFUF7R8iqq1V0FFFVpQg+pIhl5kfGjojTxy1xcTN0/xO05JwTOSSZpN4U59xJASREz
e+iuDaengqtyLfNfn58h0ie1z3Z4WVfhAhqqmGIebFqGTMlzmYr/V+szB+e++Pz7tBk1gkJD
9Keo5+xlAfqnQx5E6IjkcmB6GH52FF0MMOH6s7WPZ6buDoj+v1afL8PM0eDhXfWqRq7M+ozk
u7dkyrybzloymzZjmP87CbGkbNmXNd6NGhoZOrngbt4qa0et2g9P3GQk8HAqhgVhqsfrDmPU
dR50PMXuK4NrbKs4QyYaanMeNTp7jD8Vimic783bVmFPF/gpCiHVUeIeZsfpIGPxO0wKqg1c
8CL8CHyGNcSwUH6/fi5WCqEFUMHgSv1R88VR0f2VrVmWXGw+w3pfusA1MNCn6KaxtH6jLLru
T9VJamZJO9XCSEZRCMMxTQrPOHdZ6MMFXkwc13FZKvgw1itcl8ZZx+ZdITZCezKecYZLGYkk
KYOsJuV9KmpsYcxjD/MV4fYw9cYaSrFVMR4y+qNIsanBiM/Y40NHkqp8jDUrbvDEquDaN+ZG
rWGcOVZFXbD3FZqlYKzFZ2OMv1WiVpVjEYNBO2X7SPwn8V/P8olSRbdTGFsssqpYpWI88HiZ
e/1NJJ87wxFH6KbfZTBY/kwf2nMWJoaYP1Hxh+V/fWHEaexqs1wKoUF/7KBakmIAFUUjFgyI
gXLsogDShaRKGmkpou1a+Z8rDHCJJUAKlxjGvLDaF84y3W8EwMAysuZSgtBlLS0EAaoumzTq
tGBaCalkRgQapLtsIU1tKKywlCxQUKiKVBqApIpQlyrWEoLqUsBjQZxMS8pLDEtd0XC65FUJ
sVQwl1IlhIESRJAYOapJHArD/Qkg/8EkFSSFSSGv5vx105baDr+/Uc55FyzjgvJOE1w7fE0V
WZtAjWMzsk2SWcztjrde93Drj6SHtFvK3SBo3nlydT7RYy250p3brJMb0dJg0awj4mrPS9xr
Seydou5fSMy3VBW87F0yk0RdLb6pKlEPGU6yP/fr3I6+PT6p8qiwry+kmDsytFq4SsJ3E5zv
DnPGOu82+0XVHN1tZhvir4rNfVWan028LivVT6cqw1l012bqOSZdZO2aeKxJTrNF48rrB7NM
3d4bl6W0OMqGlRWjiBdE1TqqOPc2DGH1dG72F8bvbwaXSSTgRBd5stWeVjK6qj1J1xio7CFb
3ZXUrKdySZh5duypge4MB6tWJ7dxKznYV2cnrNSmto3RpHrGWuDKEj4QYMBEsXAxewX2RDNO
bogzOmydc29y+nYLOhtZkF12an0GZY2R6MDBfdiM8tydar2dSzdKxnsVDDTUW9MW5V6iipe2
9zKy+qLuq7U3iq67c0ZvfOus51a3YPgMYxIkEIIRYsGDEiRjEiRGIySMIgxUz11ux1fffvog
/1KDWsg7WMkknr4hsRDuzOBSXaqysVPFp62MUFC3d1uZdArst2GzBWB1l1beHVty6zCr6Fy4
rmZ1lX0Yy2DleyttcK2lJebgeb6mzuyW9uMTTh3b5wWaxdrfZqvja56gtc3Vts4phlcV2Va7
rIJpI8mOV5Bd2c3ZEgs1IOlohVcwRlhyG+kc129syd2qpSy94JZeFkVVThUGpy233dOumpKy
Rvd2rDVLrUXFvk9c7ZjYZtNK9zruJG+G3UqLWGkzstHOMjpc6tbw2grWll9MYVjr6szsnZNW
5cuboXTYtyTAmVrGWqG6TaSysdwbgrdjGbXLKh3TJeKqdvurJvSkXmTqdDumw9ljl1r3Ib19
hK7FbvGMw1Ym11bSnTmHZ6X2N1zBGDOm5Yy93YquDqaSHJh6MuFDucJtKspzBwwiUK6i8gzQ
+iJ2t3pXJM3E0M3lsPEKCiYFcQSjEY1Xer1FPb6vH0v+H8EWlEE/0ESOaf9D/VBfElw/pPLp
tOw2mf4ZTKHQfA0nu/IhScLpsLrpNpZOBcCJQXDKfV7pAyt+NI0jv+mnF51jGDCMFjyVHmx+
7FD+/wPpVD/oEVSIgqrCeRE1FG2SLUhakWoZiWVati21asJCEixgkgEIC/9qodP1cFPrVKff
zcDu7u7u7Pfv8LQDqqKqwYyCDIIbYOoI6iyGE1mMIdR4VQxgwqVDDdMqotKErBhCYjJhSSqK
pVKoqwmLLZImLnLLNucllgiCIIgiCIIlCl2MiWmSplZLZiGS7ZIAAAJWWSwAAASssm2bbXJm
QuWSwEQqCFyQkiCIIgiCIIgiCIIgyWl2stLuAiCIIgiCIIgjRJG4Wt3d3dl3G4WoDbAAACFY
xIAF3d3d23cssuBBARCoIMhJCkQRBEEQRBEEQRBW7alstqwggiCIIgiEEEQY2S7WWDCMpJQM
2khWJJAxGWgSVWJJAxGWg2yZMyZMzJkySYUwpVKpVKpVKqMYwxjBVKpVKpVKpVKpVKQbLu5J
Zd3JRBBEEQRBkW7ssZkqW5W0pbZBljMlS3K2lM2ljLkBu2S5Yy5AbtksIIUQQRKpcVbgwpVK
pVKpVKoRBEEQRBEEQRBkbllrG6xcyKxIQtFYkIWtshbWYELUkELUm2QQtSJlpC20loLLoglY
qoESxSCKS1BXaUJMHRW0sjiKl3jCP4scXVO48MwU8UGQ/QeVpjY1kZIWTSkLMtK9fyry59Qv
cy7Swp9bWrrgUwBeQYOxvW1SWrrjV8m2jMwq+EpavQtPp18KN/2u9oqq3ZzfWr55euWx1rP+
8DFdaT8VQ0iCqvxtEkEUzBB3fhqFJeqr8ve5cF08u0x7fL50XgVwWHuStE2SEHRY6G3bh7EP
39D8Ah1ViSQSkgkkk8CSQvSVVCpIgy214pJJUKBpMJJAkltxwkySMj0ooMUo1l6czLxIi1Q3
ckXLu7tpWS9VWch4yv5bzx6d5vMcbcCzTgu1pDieledWKNTw6tQoKq4yEJuGirATA+AWHU9U
92JeJZENxFNDQ5yEBTdVU/UqWJ+vQzkzgfhu+Be+Gbxq6osphrsQS+fHRIW2SWTPy/fdV5d3
d3d3d3d3fdLJ7zM6nffeN94xjGMa172xBCfI9ksIzsIwIqC0rAs9kRASVARFPV6ae/c+3Xz5
81rXu/Oc573zzz577777553vOb3ve/ec9733zz33333zzve973ve97755777777753ve973v
e977577777777777777777777777777777777777777777773eOq68afPLjz31d52VuXdmp3
imqGd83e8I6vvI6vvseL77Bvr+Lvkeru+PrL888xe3vretK03j+eryrqMiucbMbyCZrUeb1D
P6/sVIy1t51HDBGOB6HgP1vF60xKec0iHPBdKs/EAivOwKiE5rXna326p5nMzZtAEBEQuMAe
ooNyeEVDMe0l6HcspqdRtY+ksm9+yTYoq+POuFxqe3hPphvC4gQD2gx3S8+sX54ou1SpNbe9
XwIOAkxrzU66RR4Gxz1n2cPuXD5zzsFUUxwhAQzyuXaYHhq+XDVq2K+Z6FvueSY9nVwMbGhN
6sHsdlnk69Z595cuvr0VVX3Z64tir25z3aoKGdylHqwbC+0hwtnRjLi9FZpHh4DYDZcdJRRS
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

--SLDf9lqlvOQaIe6s--
