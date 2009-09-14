Return-Path: <linux-kernel-owner+w=401wt.eu-S1755516AbZINOGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbZINOGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 10:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbZINOGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 10:06:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:28430 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbZINOGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 10:06:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:message-id;
        b=lX1KKLxamLyZzeTxUh43ZmUg54sEfUrvyGlGORsD6wq37MB8eW1/MNcx5NfSyt7ZML
         0sSuHkLVXdhODq6cjNBWK6CajTPOKL29GANYsAxoeIO/XmXpBLpg+f1BMutjG9cxWgKP
         Ttipo55HPYXrkAC1y8XDvZZ+6T6pt4Zbx83Og=
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31 ehci problem - mouse dead on scroll
Date: Mon, 14 Sep 2009 16:06:16 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31r4; KDE/4.3.1; x86_64; ; )
References: <200909141602.32783.volkerarmin@googlemail.com>
In-Reply-To: <200909141602.32783.volkerarmin@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200909141606.16595.volkerarmin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Montag 14 September 2009, you wrote:

> [  720.327485] ehci_hcd 0000:00:13.2: suspend root hub


*sigh* shortly after sending the mail the mouse locked up:

[  796.056891] usb usb2: usb auto-resume                                                       
[  796.056902] ehci_hcd 0000:00:13.2: resume root hub                                          
[  796.083701] hub 2-0:1.0: hub_resume                                                         
[  796.083751] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000                                  
[  796.096460] usb 1-2: clear tt buffer port 2, a3 ep0 t800a0d42                               
[  796.097071] usb 1-2: clear tt buffer port 2, a3 ep0 t80040d42                               
[  798.337044] hub 2-0:1.0: hub_suspend                                                        
[  798.337059] usb usb2: bus auto-suspend                                                      
[  798.337064] ehci_hcd 0000:00:13.2: suspend root hub                                         
[  847.227876] usb 1-2.2: unlink qh8-0601/ffff8800c7800300 start 2 [1/2 us]                    
[  847.227892] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800300 schedule                      
[  847.227900] usb 1-2.2: link qh8-0601/ffff8800c7800300 start 2 [1/2 us]                      
[  847.227908] usb 1-2.2: unlink qh8-0601/ffff8800c7800300 start 2 [1/2 us]                    
[  847.228397] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800300 schedule                      
[  847.228403] usb 1-2.2: link qh8-0601/ffff8800c7800300 start 2 [1/2 us]                      
[  849.187876] usb 1-2.2: unlink qh8-0601/ffff8800c7800300 start 2 [1/2 us]                    
[  849.187892] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800300 schedule                      
[  849.187900] usb 1-2.2: link qh8-0601/ffff8800c7800300 start 2 [1/2 us]                      
[  849.187908] usb 1-2.2: unlink qh8-0601/ffff8800c7800300 start 2 [1/2 us]                    
[  849.188399] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800300 schedule                      
[  849.188405] usb 1-2.2: link qh8-0601/ffff8800c7800300 start 2 [1/2 us]                      
[  914.864527] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[  914.864544] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[  914.864552] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[  914.864560] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[  914.865049] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[  914.865056] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[  939.274185] usb 1-2.2: unlink qh8-0601/ffff8800c7800300 start 2 [1/2 us]                    
[  939.274201] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800300 schedule                      
[  939.274209] usb 1-2.2: link qh8-0601/ffff8800c7800300 start 2 [1/2 us]                      
[  939.274217] usb 1-2.2: unlink qh8-0601/ffff8800c7800300 start 2 [1/2 us]                    
[  939.274844] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800300 schedule                      
[  939.274851] usb 1-2.2: link qh8-0601/ffff8800c7800300 start 2 [1/2 us]                      
[ 1087.528888] usb 1-2.2: unlink qh8-0601/ffff8800c7800300 start 2 [1/2 us]                    
[ 1087.528904] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800300 schedule                      
[ 1087.528912] usb 1-2.2: link qh8-0601/ffff8800c7800300 start 2 [1/2 us]                      
[ 1087.528921] usb 1-2.2: unlink qh8-0601/ffff8800c7800300 start 2 [1/2 us]                    
[ 1087.529521] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800300 schedule                      
[ 1087.529530] usb 1-2.2: link qh8-0601/ffff8800c7800300 start 2 [1/2 us]                      
[ 1116.931180] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1116.931196] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1116.931204] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1116.931213] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1116.931663] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1116.931669] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1116.991182] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1116.991197] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1116.991203] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1116.991211] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1116.992183] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1116.992193] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1117.051184] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1117.051200] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1117.051206] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1117.051214] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1117.051930] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1117.051940] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1117.211181] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1117.211196] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1117.211204] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1117.211213] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1117.211226] usb 1-2.2: unlink qh8-0601/ffff8800c7800300 start 2 [1/2 us]                    
[ 1117.211236] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800300 schedule                      
[ 1117.211242] usb 1-2.2: link qh8-0601/ffff8800c7800300 start 2 [1/2 us]                      
[ 1117.211250] usb 1-2.2: unlink qh8-0601/ffff8800c7800300 start 2 [1/2 us]                    
[ 1117.211645] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1117.211651] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1117.212167] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800300 schedule                      
[ 1117.212177] usb 1-2.2: link qh8-0601/ffff8800c7800300 start 2 [1/2 us]                      
[ 1117.271180] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1117.271198] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1117.271206] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1117.271215] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1117.272173] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1117.272183] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1117.431181] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1117.431197] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1117.431205] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1117.431214] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1117.431781] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1117.431791] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1117.686367] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1117.686383] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1117.686390] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1117.686399] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1117.686857] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1117.686864] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1117.711166] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1117.711181] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1117.711187] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1117.711194] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1117.712113] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1117.712119] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1117.771158] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1117.771165] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1117.771167] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1117.771170] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1117.771854] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1117.771857] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1117.831158] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1117.831165] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1117.831167] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1117.831170] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1117.832096] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1117.832098] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1118.191175] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1118.191191] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1118.191198] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1118.191207] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1118.191712] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1118.191719] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1118.251177] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1118.251193] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1118.251201] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1118.251209] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1118.251832] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1118.251838] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1118.711173] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1118.711189] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1118.711197] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1118.711205] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1118.712432] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1118.712441] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1118.771178] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1118.771194] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1118.771201] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1118.771210] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1118.771802] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1118.771809] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1119.531173] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1119.531189] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1119.531198] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1119.531206] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1119.531755] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1119.531762] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1119.591181] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1119.591197] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1119.591204] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1119.591212] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1119.592773] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1119.592782] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1120.557845] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1120.557861] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1120.557869] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1120.557878] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1120.558463] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1120.558472] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1120.617847] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1120.617861] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1120.617867] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1120.617874] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1120.618954] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1120.618963] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1120.677844] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1120.677858] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1120.677864] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1120.677871] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1120.678452] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1120.678461] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1120.737845] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1120.737859] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1120.737865] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1120.737872] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1120.738946] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1120.738955] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.097841] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.097854] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.097861] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.097868] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.098275] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.098281] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.157843] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.157856] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.157862] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.157870] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.158417] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.158426] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.217845] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.217859] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.217865] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.217872] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.218916] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.218924] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.277843] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.277856] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.277862] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.277869] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.278415] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.278423] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.337838] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.337851] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.337857] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.337865] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.338908] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.338917] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.397843] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.397856] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.397862] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.397870] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.398405] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.398413] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.457844] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.457858] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.457864] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.457872] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.458900] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.458909] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.517843] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.517856] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.517862] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.517869] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.518395] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.518404] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.577844] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.577858] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.577864] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.577871] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.578893] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.578902] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.637843] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.637856] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.637862] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.637870] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.638391] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.638400] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.684871] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.684885] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.684890] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.684898] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.685262] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.685268] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.697847] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.697859] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.697865] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.697873] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.699013] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.699021] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.717845] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.717858] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.717864] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.717871] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.718235] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.718241] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.727843] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.727856] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.727862] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.727869] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.728873] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.728881] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.787844] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.787856] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.787862] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.787869] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.788357] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.788363] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.847841] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.847854] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.847860] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.847867] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.848626] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.848634] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.907843] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.907856] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.907862] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.907869] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.908349] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.908355] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.967841] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.967854] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.967860] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1121.967867] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1121.968618] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1121.968627] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1122.127841] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1122.127854] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1122.127860] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1122.127867] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1122.128335] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1122.128341] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1122.187843] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1122.187856] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1122.187861] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1122.187869] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1122.188331] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1122.188337] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1122.247841] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1122.247854] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1122.247859] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1122.247867] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1122.248601] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1122.248609] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1122.307843] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1122.307856] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1122.307862] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1122.307869] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1122.308324] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1122.308330] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1122.367832] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1122.367846] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1122.367852] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1122.367860] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1122.368593] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1122.368601] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1122.427843] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1122.427856] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1122.427862] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1122.427869] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1122.428317] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1122.428323] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1122.487841] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1122.487854] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1122.487860] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1122.487867] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1122.488586] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1122.488594] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1122.547845] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1122.547858] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1122.547864] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1122.547871] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1122.548309] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1122.548315] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1122.607841] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1122.607854] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1122.607860] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1122.607867] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1122.608578] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1122.608586] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1122.667843] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1122.667856] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1122.667862] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1122.667870] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1122.668302] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1122.668308] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1122.727841] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1122.727854] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1122.727860] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1122.727867] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1122.728571] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1122.728579] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1122.787843] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1122.787856] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1122.787862] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1122.787869] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1122.788294] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1122.788300] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1122.847841] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1122.847854] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1122.847860] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1122.847867] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1122.848563] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1122.848571] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1122.907846] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1122.907861] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1122.907868] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1122.907875] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1122.908287] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1122.908293] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1122.967845] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1122.967861] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1122.967867] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1122.967875] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1122.968552] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1122.968561] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.027851] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.027866] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.027872] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.027880] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.028282] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.028288] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.087847] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.087862] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.087868] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.087875] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.088553] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.088563] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.147853] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.147869] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.147875] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.147882] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.148275] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.148281] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.207849] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.207864] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.207870] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.207877] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.208546] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.208555] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.267848] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.267863] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.267869] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.267876] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.268265] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.268271] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.327846] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.327860] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.327866] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.327874] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.328539] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.328548] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.387850] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.387865] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.387871] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.387878] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.388259] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.388265] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.447843] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.447857] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.447862] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.447870] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.448530] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.448539] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.507845] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.507858] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.507864] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.507871] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.508250] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.508256] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.567835] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.567850] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.567855] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.567863] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.568520] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.568529] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.627844] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.627857] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.627863] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.627870] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.628389] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.628397] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.686365] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.686378] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.686384] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.686391] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.686737] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.686743] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.711178] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.711191] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.711197] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.711204] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.711737] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.711743] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.771177] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.771189] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.771195] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.771203] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.772255] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.772263] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.831175] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.831188] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.831193] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.831201] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.831753] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.831761] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.891176] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.891189] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.891195] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.891202] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.892247] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.892256] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.951174] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.951187] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.951193] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1123.951200] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1123.951741] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1123.951749] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1124.011177] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1124.011190] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1124.011196] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1124.011203] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1124.012241] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1124.012249] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1124.071174] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1124.071187] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1124.071193] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1124.071200] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1124.071732] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1124.071740] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1124.131176] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1124.131189] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1124.131195] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1124.131202] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1124.132233] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1124.132241] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1124.191164] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1124.191177] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1124.191183] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1124.191190] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1124.191801] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1124.191808] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1124.251176] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1124.251189] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1124.251194] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1124.251202] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1124.252224] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1124.252232] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1124.311174] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1124.311187] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1124.311193] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1124.311200] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1124.311715] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1124.311724] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1124.371176] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1124.371189] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1124.371195] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1124.371202] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1124.372217] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[ 1124.372225] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[ 1136.281164] ehci_hcd 0000:00:13.2: remove, state 4                                          
[ 1136.281171] ehci_hcd 0000:00:13.2: roothub graceful disconnect                              
[ 1136.281184] usb usb2: USB disconnect, address 1                                             
[ 1136.281189] usb usb2: unregistering device                                                  
[ 1136.281193] usb usb2: usb_disable_device nuking all URBs                                    
[ 1136.281201] usb usb2: unregistering interface 2-0:1.0                                       
[ 1136.281298] usb 2-0:1.0: uevent                                                             
[ 1136.281613] usb usb2: uevent                                                                
[ 1136.281743] ehci_hcd 0000:00:13.2: stop                                                     
[ 1136.281761] ehci_hcd 0000:00:13.2: reset command 01000a (park)=0 ithresh=1 
period=256 Reset HALT                                                                                           
[ 1136.281792] ehci_hcd 0000:00:13.2: irq normal 0 err 0 reclaim 0 (lost 0)                    
[ 1136.281797] ehci_hcd 0000:00:13.2: complete 0 unlink 0                                      
[ 1136.281806] ehci_hcd 0000:00:13.2: ehci_stop completed status 1000 Halt                     
[ 1136.281819] ehci_hcd 0000:00:13.2: USB bus 2 deregistered                                   
[ 1136.282601] ehci_hcd 0000:00:13.2: PCI INT B disabled                                       
[ 1136.282621] ehci_hcd 0000:00:12.2: remove, state 1                                          
[ 1136.282625] ehci_hcd 0000:00:12.2: roothub graceful disconnect                              
[ 1136.282639] usb usb1: USB disconnect, address 1                                             
[ 1136.282643] usb 1-2: USB disconnect, address 2                                              
[ 1136.282647] usb 1-2.2: USB disconnect, address 3                                            
[ 1136.282652] usb 1-2.2: unregistering device                                                 
[ 1136.282656] usb 1-2.2: usb_disable_device nuking all URBs                                   
[ 1136.282695] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[ 1136.282708] ehci_hcd 0000:00:12.2: shutdown urb ffff880233964f00 ep1in-intr                 
[ 1136.282717] usb 1-2.2: unlink qh8-0601/ffff8800c7800300 start 2 [1/2 us]                    
[ 1136.282726] ehci_hcd 0000:00:12.2: shutdown urb ffff880234163840 ep2in-intr                 
[ 1136.282732] usb 1-2.2: unregistering interface 1-2.2:1.0                                    
[ 1136.307349] usb 1-2.2:1.0: uevent                                                           
[ 1136.307462] usb 1-2.2: unregistering interface 1-2.2:1.1                                    
[ 1136.331905] drivers/usb/core/file.c: removing 96 minor                                      
[ 1136.333098] usb 1-2.2:1.1: uevent                                                           
[ 1136.335323] usb 1-2.2: uevent                                                               
[ 1136.335452] usb 1-2.4: USB disconnect, address 4                                            
[ 1136.335458] usb 1-2.4: unregistering device                                                 
[ 1136.335462] usb 1-2.4: usb_disable_device nuking all URBs                                   
[ 1136.335472] usb 1-2.4: unregistering interface 1-2.4:128.0                                  
[ 1136.340302] usb 1-2.4:128.0: uevent                                                         
[ 1136.340551] usb 1-2.4: uevent                                                               
[ 1136.340577] usb 1-2: unregistering device                                                   
[ 1136.340582] usb 1-2: usb_disable_device nuking all URBs                                     
[ 1136.340593] usb 1-2: unlink qh256-0001/ffff8800c7800180 start 1 [1/0 us]                    
[ 1136.340663] ehci_hcd 0000:00:12.2: shutdown urb ffff880234184840 ep1in-intr                 
[ 1136.340669] usb 1-2: unregistering interface 1-2:1.0                                        
[ 1136.340753] usb 1-2:1.0: uevent                                                             
[ 1136.341111] usb 1-2: uevent                                                                 
[ 1136.341750] usb usb1: unregistering device                                                  
[ 1136.341755] usb usb1: usb_disable_device nuking all URBs                                    
[ 1136.341764] ehci_hcd 0000:00:12.2: shutdown urb ffff880234d37540 ep1in-intr                 
[ 1136.341770] usb usb1: unregistering interface 1-0:1.0                                       
[ 1136.341872] usb 1-0:1.0: uevent                                                             
[ 1136.342167] usb usb1: uevent                                                                
[ 1136.342307] ehci_hcd 0000:00:12.2: stop                                                     
[ 1136.342435] ehci_hcd 0000:00:12.2: reset command 01000a (park)=0 ithresh=1 
period=256 Reset HALT                                                                                           
[ 1136.342698] ehci_hcd 0000:00:12.2: irq normal 24498 err 6 reclaim 1156 
(lost 0)             
[ 1136.342705] ehci_hcd 0000:00:12.2: complete 24750 unlink 3                                  
[ 1136.342714] ehci_hcd 0000:00:12.2: ehci_stop completed status 1000 Halt                     
[ 1136.342726] ehci_hcd 0000:00:12.2: USB bus 1 deregistered                                   
[ 1136.343452] ehci_hcd 0000:00:12.2: PCI INT B disabled                                       
[ 1140.039868] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver                      
[ 1140.039876] ehci_hcd: block sizes: qh 192 qtd 96 itd 192 sitd 96                            
[ 1140.039932] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 
17               
[ 1140.039999] ehci_hcd 0000:00:12.2: EHCI Host Controller                                     
[ 1140.040032] drivers/usb/core/inode.c: creating file 'devices'                               
[ 1140.040041] drivers/usb/core/inode.c: creating file '001'                                   
[ 1140.040210] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus 
number 1            
[ 1140.040227] ehci_hcd 0000:00:12.2: reset hcs_params 0x102306 dbg=1 cc=2 
pcc=3 ordered !ppc ports=6                                                                                         
[ 1140.040237] ehci_hcd 0000:00:12.2: reset hcc_params a072 thresh 7 uframes 
256/512/1024      
[ 1140.040274] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze 
workaround           
[ 1140.040289] ehci_hcd 0000:00:12.2: reset command 080002 (park)=0 ithresh=8 
period=1024 Reset HALT                                                                                          
[ 1140.040310] ehci_hcd 0000:00:12.2: debug port 1                                             
[ 1140.040318] ehci_hcd 0000:00:12.2: MWI active                                               
[ 1140.040322] ehci_hcd 0000:00:12.2: supports USB remote wakeup                               
[ 1140.040342] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfddff000                                
[ 1140.040351] ehci_hcd 0000:00:12.2: reset command 080002 (park)=0 ithresh=8 
period=1024 Reset HALT                                                                                          
[ 1140.040364] ehci_hcd 0000:00:12.2: init command 010009 (park)=0 ithresh=1 
period=256 RUN    
[ 1140.057423] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00                               
[ 1140.057475] usb usb1: default language 0x0409                                               
[ 1140.057491] usb usb1: udev 1, busnum 1, minor = 0                                           
[ 1140.057496] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002                   
[ 1140.057501] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1              
[ 1140.057507] usb usb1: Product: EHCI Host Controller                                         
[ 1140.057511] usb usb1: Manufacturer: Linux 2.6.31r4 ehci_hcd                                 
[ 1140.057515] usb usb1: SerialNumber: 0000:00:12.2                                            
[ 1140.057613] usb usb1: uevent                                                                
[ 1140.057747] usb usb1: usb_probe_device                                                      
[ 1140.057754] usb usb1: configuration #1 chosen from 1 choice                                 
[ 1140.057770] usb usb1: adding 1-0:1.0 (config #1, interface 0)                               
[ 1140.057802] usb 1-0:1.0: uevent                                                             
[ 1140.057876] hub 1-0:1.0: usb_probe_interface                                                
[ 1140.057881] hub 1-0:1.0: usb_probe_interface - got id                                       
[ 1140.057886] hub 1-0:1.0: USB hub found                                                      
[ 1140.057907] hub 1-0:1.0: 6 ports detected                                                   
[ 1140.057910] hub 1-0:1.0: standalone hub                                                     
[ 1140.057914] hub 1-0:1.0: no power switching (usb 1.0)                                       
[ 1140.057918] hub 1-0:1.0: individual port over-current protection                            
[ 1140.057924] hub 1-0:1.0: power on to power good time: 20ms                                  
[ 1140.057933] hub 1-0:1.0: local power source is good                                         
[ 1140.057939] hub 1-0:1.0: trying to enable port power on non-switchable hub                  
[ 1140.057992] drivers/usb/core/inode.c: creating file '001'                                   
[ 1140.058056] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 
19               
[ 1140.058094] ehci_hcd 0000:00:13.2: EHCI Host Controller                                     
[ 1140.058108] drivers/usb/core/inode.c: creating file '002'                                   
[ 1140.058806] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus 
number 2            
[ 1140.058822] ehci_hcd 0000:00:13.2: reset hcs_params 0x102306 dbg=1 cc=2 
pcc=3 ordered !ppc ports=6                                                                                         
[ 1140.058831] ehci_hcd 0000:00:13.2: reset hcc_params a072 thresh 7 uframes 
256/512/1024      
[ 1140.058866] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze 
workaround           
[ 1140.058880] ehci_hcd 0000:00:13.2: reset command 080002 (park)=0 ithresh=8 
period=1024 Reset HALT                                                                                          
[ 1140.058901] ehci_hcd 0000:00:13.2: debug port 1                                             
[ 1140.058908] ehci_hcd 0000:00:13.2: MWI active                                               
[ 1140.058912] ehci_hcd 0000:00:13.2: supports USB remote wakeup                               
[ 1140.058931] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfddf6800                                
[ 1140.058941] ehci_hcd 0000:00:13.2: reset command 080002 (park)=0 ithresh=8 
period=1024 Reset HALT                                                                                          
[ 1140.058953] ehci_hcd 0000:00:13.2: init command 010009 (park)=0 ithresh=1 
period=256 RUN    
[ 1140.067429] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00                               
[ 1140.067476] usb usb2: default language 0x0409                                               
[ 1140.067489] usb usb2: udev 1, busnum 2, minor = 128                                         
[ 1140.067494] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002                   
[ 1140.067499] usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1              
[ 1140.067504] usb usb2: Product: EHCI Host Controller                                         
[ 1140.067508] usb usb2: Manufacturer: Linux 2.6.31r4 ehci_hcd                                 
[ 1140.067512] usb usb2: SerialNumber: 0000:00:13.2                                            
[ 1140.067601] usb usb2: uevent                                                                
[ 1140.068855] usb usb2: usb_probe_device                                                      
[ 1140.068862] usb usb2: configuration #1 chosen from 1 choice                                 
[ 1140.068878] usb usb2: adding 2-0:1.0 (config #1, interface 0)                               
[ 1140.068915] usb 2-0:1.0: uevent                                                             
[ 1140.069951] hub 2-0:1.0: usb_probe_interface                                                
[ 1140.069958] hub 2-0:1.0: usb_probe_interface - got id                                       
[ 1140.069963] hub 2-0:1.0: USB hub found                                                      
[ 1140.069980] hub 2-0:1.0: 6 ports detected                                                   
[ 1140.069984] hub 2-0:1.0: standalone hub                                                     
[ 1140.069987] hub 2-0:1.0: no power switching (usb 1.0)                                       
[ 1140.069991] hub 2-0:1.0: individual port over-current protection                            
[ 1140.069996] hub 2-0:1.0: power on to power good time: 20ms                                  
[ 1140.070004] hub 2-0:1.0: local power source is good                                         
[ 1140.070009] hub 2-0:1.0: trying to enable port power on non-switchable hub                  
[ 1140.071990] drivers/usb/core/inode.c: creating file '001'                                   
[ 1140.157412] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001803 POWER 
sig=j CSC CONNECT   
[ 1140.157415] hub 1-0:1.0: port 2: status 0501 change 0001                                    
[ 1140.170759] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000                                  
[ 1140.257426] hub 1-0:1.0: state 7 ports 6 chg 0004 evt 0000                                  
[ 1140.257447] hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s                         
[ 1140.311193] ehci_hcd 0000:00:12.2: port 2 high speed                                        
[ 1140.311204] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER 
sig=se0 PE CONNECT  
[ 1140.364512] usb 1-2: new high speed USB device using ehci_hcd and address 2                 
[ 1140.417865] ehci_hcd 0000:00:12.2: port 2 high speed                                        
[ 1140.417876] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER 
sig=se0 PE CONNECT  
[ 1140.489350] usb 1-2: default language 0x0409                                                
[ 1140.489723] usb 1-2: udev 2, busnum 1, minor = 1                                            
[ 1140.489728] usb 1-2: New USB device found, idVendor=05e3, idProduct=0608                    
[ 1140.489733] usb 1-2: New USB device strings: Mfr=0, Product=1, 
SerialNumber=0               
[ 1140.489738] usb 1-2: Product: USB2.0 Hub                                                    
[ 1140.489852] usb 1-2: uevent                                                                 
[ 1140.489887] usb 1-2: usb_probe_device                                                       
[ 1140.489893] usb 1-2: configuration #1 chosen from 1 choice                                  
[ 1140.490113] usb 1-2: adding 1-2:1.0 (config #1, interface 0)                                
[ 1140.490151] usb 1-2:1.0: uevent                                                             
[ 1140.490177] hub 1-2:1.0: usb_probe_interface                                                
[ 1140.490182] hub 1-2:1.0: usb_probe_interface - got id                                       
[ 1140.490187] hub 1-2:1.0: USB hub found                                                      
[ 1140.490474] hub 1-2:1.0: 4 ports detected                                                   
[ 1140.490478] hub 1-2:1.0: standalone hub                                                     
[ 1140.490482] hub 1-2:1.0: individual port power switching                                    
[ 1140.490487] hub 1-2:1.0: individual port over-current protection                            
[ 1140.490491] hub 1-2:1.0: Single TT                                                          
[ 1140.490496] hub 1-2:1.0: TT requires at most 32 FS bit times (2664 ns)                      
[ 1140.490501] hub 1-2:1.0: Port indicators are supported                                      
[ 1140.490506] hub 1-2:1.0: power on to power good time: 100ms                                 
[ 1140.490967] hub 1-2:1.0: local power source is good                                         
[ 1140.490973] hub 1-2:1.0: enabling power on all ports                                        
[ 1140.493261] drivers/usb/core/inode.c: creating file '002'                                   
[ 1140.591722] hub 1-2:1.0: port 2: status 0301 change 0001                                    
[ 1140.592467] hub 1-2:1.0: port 4: status 0101 change 0001                                    
[ 1140.691175] usb 1-2: link qh256-0001/ffff8800c7809180 start 1 [1/0 us]                      
[ 1140.691194] hub 1-2:1.0: state 7 ports 4 chg 0014 evt 0000                                  
[ 1140.691475] hub 1-2:1.0: port 2, status 0301, change 0000, 1.5 Mb/s                         
[ 1140.758506] usb 1-2.2: new low speed USB device using ehci_hcd and address 
3                
[ 1140.845607] usb 1-2.2: skipped 1 descriptor after interface                                 
[ 1140.845615] usb 1-2.2: skipped 1 descriptor after interface                                 
[ 1140.846094] usb 1-2.2: default language 0x0409                                              
[ 1140.848221] usb 1-2.2: udev 3, busnum 1, minor = 2                                          
[ 1140.848228] usb 1-2.2: New USB device found, idVendor=046d, idProduct=c518                  
[ 1140.848233] usb 1-2.2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0             
[ 1140.848238] usb 1-2.2: Product: USB Receiver
[ 1140.848242] usb 1-2.2: Manufacturer: Logitech
[ 1140.848347] usb 1-2.2: uevent
[ 1140.848374] usb 1-2.2: usb_probe_device
[ 1140.848380] usb 1-2.2: configuration #1 chosen from 1 choice
[ 1140.855729] usb 1-2.2: adding 1-2.2:1.0 (config #1, interface 0)
[ 1140.855777] usb 1-2.2:1.0: uevent
[ 1140.855811] usbhid 1-2.2:1.0: usb_probe_interface
[ 1140.855815] usbhid 1-2.2:1.0: usb_probe_interface - got id
[ 1140.856198] usb 1-2: clear tt buffer port 2, a3 ep0 t80008d42
[ 1140.859294] input: Logitech USB Receiver as 
/devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.2/1-2.2:1.0/input/input5
[ 1140.859433] generic-usb 0003:046D:C518.0003: input,hidraw0: USB HID v1.11 
Mouse [Logitech USB Receiver] on usb-0000:00:12.2-2.2/input0
[ 1140.859466] usb 1-2.2: adding 1-2.2:1.1 (config #1, interface 1)
[ 1140.859501] usb 1-2.2:1.1: uevent
[ 1140.859527] usbhid 1-2.2:1.1: usb_probe_interface
[ 1140.859531] usbhid 1-2.2:1.1: usb_probe_interface - got id
[ 1140.860197] usb 1-2: clear tt buffer port 2, a3 ep0 t80008d42
[ 1140.865044] usb 1-2.2:1.0: uevent
[ 1140.865210] usb 1-2.2: uevent
[ 1140.866779] input: Logitech USB Receiver as 
/devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.2/1-2.2:1.1/input/input6
[ 1140.866804] usb 1-2.2: link qh8-0601/ffff8800c7809300 start 2 [1/2 us]
[ 1140.866864] drivers/usb/core/file.c: looking for a minor, starting at 96
[ 1140.866972] generic-usb 0003:046D:C518.0004: input,hiddev96,hidraw1: USB 
HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.2-2.2/input1
[ 1140.867006] drivers/usb/core/inode.c: creating file '003'
[ 1140.867236] usb 1-2.2:1.0: uevent
[ 1140.868308] hub 1-2:1.0: port 4, status 0101, change 0000, 12 Mb/s
[ 1140.869364] usb 1-2.2:1.0: uevent
[ 1140.869547] usb 1-2.2: uevent
[ 1140.872164] usb 1-2.2:1.0: uevent
[ 1140.872695] usb 1-2.2:1.1: uevent
[ 1140.872865] usb 1-2.2: uevent
[ 1140.876484] usb 1-2.2:1.1: uevent
[ 1140.897853] usb 1-2.2: link qh8-0601/ffff8800c78093c0 start 3 [1/2 us]
[ 1140.938244] usb 1-2.4: new high speed USB device using ehci_hcd and address 
4
[ 1141.023311] usb 1-2.4: default language 0x0409
[ 1141.024431] usb 1-2.4: udev 4, busnum 1, minor = 3
[ 1141.024432] usb 1-2.4: New USB device found, idVendor=0781, idProduct=7421
[ 1141.024434] usb 1-2.4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[ 1141.024436] usb 1-2.4: Product: Sansa e260
[ 1141.024437] usb 1-2.4: Manufacturer: SanDisk
[ 1141.024438] usb 1-2.4: SerialNumber: 
00000000-00000000-8911b49b-9905e904-00000000
[ 1141.024507] usb 1-2.4: uevent
[ 1141.024520] usb 1-2.4: usb_probe_device
[ 1141.024522] usb 1-2.4: configuration #128 chosen from 1 choice
[ 1141.043813] usb 1-2.4: adding 1-2.4:128.0 (config #128, interface 0)
[ 1141.043833] usb 1-2.4:128.0: uevent
[ 1141.043848] usb-storage 1-2.4:128.0: usb_probe_interface
[ 1141.043851] usb-storage 1-2.4:128.0: usb_probe_interface - got id
[ 1141.047555] scsi7 : SCSI emulation for USB Mass Storage devices
[ 1141.047781] usb-storage: device found at 4
[ 1141.047787] usb-storage: waiting for device to settle before scanning
[ 1141.047785] drivers/usb/core/inode.c: creating file '004'
[ 1141.047811] hub 1-2:1.0: state 7 ports 4 chg 0000 evt 0004
[ 1142.317838] hub 2-0:1.0: hub_suspend
[ 1142.317853] usb usb2: bus auto-suspend
[ 1142.317859] ehci_hcd 0000:00:13.2: suspend root hub
