Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbYIOIWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbYIOIWN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 04:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbYIOIVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 04:21:45 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:2176 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbYIOIVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 04:21:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=sU2IwbzWOwG+U6cgQxsOuWuFrU9aatK1eeE52xEuxJ0ilLOKE7W93W2fmrPIF9FqUO
         LEY8+0fzssQAN4wEEA032EAiipHJrTTHmgLAg6amdrHrvBILPmGS/wFNjpx4MQURyhFh
         ZuoOoblM4/DAehTXPAI2P+comdTUpaJEq+s/0=
Message-ID: <dd18b0c30809150121v6900a6fxcf17000b60955eb7@mail.gmail.com>
Date: Mon, 15 Sep 2008 01:21:42 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Buffer I/O error on device sr0, logical block 793066
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I guess russell crow doesnt have a problem with me(Gladiator), but
as soon as jodie foster is the main character(Panic Room);
 I receieve this:


[14417.951134] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[14417.951150] sr 0:0:0:0: [sr0] Sense Key : Hardware Error [current]
[14417.951160] Info fld=0xc1a00
[14417.951163] sr 0:0:0:0: [sr0] Add. Sense: Track following error
[14417.951172] end_request: I/O error, dev sr0, sector 3172264
[14417.951181] Buffer I/O error on device sr0, logical block 793066
[14417.951192] Buffer I/O error on device sr0, logical block 793067
[14417.951206] Buffer I/O error on device sr0, logical block 793068
[14417.951213] Buffer I/O error on device sr0, logical block 793069
[14417.951221] Buffer I/O error on device sr0, logical block 793070
[14417.951228] Buffer I/O error on device sr0, logical block 793071
[14417.951235] Buffer I/O error on device sr0, logical block 793072
[14417.951242] Buffer I/O error on device sr0, logical block 793073
[14417.951249] Buffer I/O error on device sr0, logical block 793074
[14417.951257] Buffer I/O error on device sr0, logical block 793075
[14419.656189] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[14419.656203] sr 0:0:0:0: [sr0] Sense Key : Hardware Error [current]
[14419.656213] Info fld=0xc1a30
[14419.656216] sr 0:0:0:0: [sr0] Add. Sense: Track following error
[14419.656225] end_request: I/O error, dev sr0, sector 3172520
[14422.501929] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[14422.501945] sr 0:0:0:0: [sr0] Sense Key : Hardware Error [current]
[14422.501954] Info fld=0xc1a30
[14422.501957] sr 0:0:0:0: [sr0] Add. Sense: Track following error
[14422.501967] end_request: I/O error, dev sr0, sector 3172544
[14425.526546] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[14425.526561] sr 0:0:0:0: [sr0] Sense Key : Hardware Error [current]
[14425.526571] Info fld=0xc1a31
[14425.526574] sr 0:0:0:0: [sr0] Add. Sense: Track following error
[14425.526584] end_request: I/O error, dev sr0, sector 3172548
[14425.526591] __ratelimit: 119 callbacks suppressed
[14425.526596] Buffer I/O error on device sr0, logical block 793137
[14428.691672] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[14428.691688] sr 0:0:0:0: [sr0] Sense Key : Hardware Error [current]
[14428.691698] Info fld=0xc1a30
[14428.691701] sr 0:0:0:0: [sr0] Add. Sense: Track following error
[14428.691710] end_request: I/O error, dev sr0, sector 3172544
[14428.691719] Buffer I/O error on device sr0, logical block 793136
[14428.691733] Buffer I/O error on device sr0, logical block 793137
[14430.968223] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[14430.968238] sr 0:0:0:0: [sr0] Sense Key : Hardware Error [current]
[14430.968247] Info fld=0xc1a32
[14430.968251] sr 0:0:0:0: [sr0] Add. Sense: Track following error
[14430.968260] end_request: I/O error, dev sr0, sector 3172552
[14430.968268] Buffer I/O error on device sr0, logical block 793138
[14432.675723] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[14432.675739] sr 0:0:0:0: [sr0] Sense Key : Hardware Error [current]
[14432.675749] Info fld=0xc1a33
[14432.675752] sr 0:0:0:0: [sr0] Add. Sense: Track following error
[14432.675761] end_request: I/O error, dev sr0, sector 3172556
[14432.675770] Buffer I/O error on device sr0, logical block 793139
[14435.414780] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[14435.414797] sr 0:0:0:0: [sr0] Sense Key : Hardware Error [current]
[14435.414806] Info fld=0xc1a32
[14435.414809] sr 0:0:0:0: [sr0] Add. Sense: Track following error
[14435.414819] end_request: I/O error, dev sr0, sector 3172552
[14435.414828] Buffer I/O error on device sr0, logical block 793138
[14435.414843] Buffer I/O error on device sr0, logical block 793139
[14437.727108] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[14437.727123] sr 0:0:0:0: [sr0] Sense Key : Hardware Error [current]
[14437.727133] Info fld=0xc1a34
[14437.727136] sr 0:0:0:0: [sr0] Add. Sense: Track following error
[14437.727146] end_request: I/O error, dev sr0, sector 3172560
[14437.727154] Buffer I/O error on device sr0, logical block 793140
[14440.039336] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[14440.039353] sr 0:0:0:0: [sr0] Sense Key : Hardware Error [current]
[14440.039363] Info fld=0xc1a35
[14440.039366] sr 0:0:0:0: [sr0] Add. Sense: Track following error
[14440.039375] end_request: I/O error, dev sr0, sector 3172564
[14440.039384] Buffer I/O error on device sr0, logical block 793141
[14442.885029] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[14442.885044] sr 0:0:0:0: [sr0] Sense Key : Hardware Error [current]
[14442.885053] Info fld=0xc1a34
[14442.885056] sr 0:0:0:0: [sr0] Add. Sense: Track following error
[14442.885066] end_request: I/O error, dev sr0, sector 3172560
[14442.885074] Buffer I/O error on device sr0, logical block 793140
[14442.885089] Buffer I/O error on device sr0, logical block 793141
[14445.161664] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[14445.161679] sr 0:0:0:0: [sr0] Sense Key : Hardware Error [current]
[14445.161688] Info fld=0xc1a36
[14445.161691] sr 0:0:0:0: [sr0] Add. Sense: Track following error
[14445.161701] end_request: I/O error, dev sr0, sector 3172568
[14445.161709] Buffer I/O error on device sr0, logical block 793142
[14447.900778] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[14447.900794] sr 0:0:0:0: [sr0] Sense Key : Hardware Error [current]
[14447.900804] Info fld=0xc1a37
[14447.900807] sr 0:0:0:0: [sr0] Add. Sense: Track following error
[14447.900816] end_request: I/O error, dev sr0, sector 3172572
[14447.900825] Buffer I/O error on device sr0, logical block 793143
[14450.497524] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[14450.497540] sr 0:0:0:0: [sr0] Sense Key : Hardware Error [current]
[14450.497549] Info fld=0xc1a36
[14450.497553] sr 0:0:0:0: [sr0] Add. Sense: Track following error
[14450.497562] end_request: I/O error, dev sr0, sector 3172568
[14450.497571] Buffer I/O error on device sr0, logical block 793142
[14450.497585] Buffer I/O error on device sr0, logical block 793143
[14452.774312] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[14452.774326] sr 0:0:0:0: [sr0] Sense Key : Hardware Error [current]
[14452.774336] Info fld=0xc1a38
[14452.774339] sr 0:0:0:0: [sr0] Add. Sense: Track following error
[14452.774349] end_request: I/O error, dev sr0, sector 3172576
[14452.774357] Buffer I/O error on device sr0, logical block 793144
[14455.050895] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[14455.050911] sr 0:0:0:0: [sr0] Sense Key : Hardware Error [current]
[14455.050920] Info fld=0xc1a39
[14455.050923] sr 0:0:0:0: [sr0] Add. Sense: Track following error
[14455.050933] end_request: I/O error, dev sr0, sector 3172580
[14455.050941] Buffer I/O error on device sr0, logical block 793145
[14461.916822] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[14461.916838] sr 0:0:0:0: [sr0] Sense Key : Hardware Error [current]
[14461.916847] Info fld=0xc1c70
[14461.916850] sr 0:0:0:0: [sr0] Add. Sense: Track following error
[14461.916860] end_request: I/O error, dev sr0, sector 3174848
[14461.916869] Buffer I/O error on device sr0, logical block 793712
[14465.295650] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[14465.295666] sr 0:0:0:0: [sr0] Sense Key : Hardware Error [current]
[14465.295676] Info fld=0xc1c71
[14465.295679] sr 0:0:0:0: [sr0] Add. Sense: Track following error
[14465.295688] end_request: I/O error, dev sr0, sector 3174852
[14465.295696] Buffer I/O error on device sr0, logical block 793713
[14468.143259] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[14468.143274] sr 0:0:0:0: [sr0] Sense Key : Hardware Error [current]
[14468.143283] Info fld=0xc1c70
[14468.143286] sr 0:0:0:0: [sr0] Add. Sense: Track following error
[14468.143296] end_request: I/O error, dev sr0, sector 3174848
[14468.143304] Buffer I/O error on device sr0, logical block 793712
[14468.143318] Buffer I/O error on device sr0, logical block 793713
[14472.695740] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[14472.695755] sr 0:0:0:0: [sr0] Sense Key : Hardware Error [current]
[14472.695764] Info fld=0xc1c72
[14472.695767] sr 0:0:0:0: [sr0] Add. Sense: Track following error
[14472.695777] end_request: I/O error, dev sr0, sector 3174856
[14472.695785] Buffer I/O error on device sr0, logical block 793714
[14476.786128] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[14476.786143] sr 0:0:0:0: [sr0] Sense Key : Hardware Error [current]
[14476.786152] Info fld=0xc1c73
[14476.786156] sr 0:0:0:0: [sr0] Add. Sense: Track following error
[14476.786165] end_request: I/O error, dev sr0, sector 3174860
[14476.786173] Buffer I/O error on device sr0, logical block 793715
[14481.233572] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[14481.233587] sr 0:0:0:0: [sr0] Sense Key : Hardware Error [current]
[14481.233597] Info fld=0xc1c72
[14481.233600] sr 0:0:0:0: [sr0] Add. Sense: Track following error
[14481.233609] end_request: I/O error, dev sr0, sector 3174856
[14481.233618] Buffer I/O error on device sr0, logical block 793714
[14481.233633] Buffer I/O error on device sr0, logical block 793715
[14486.712696] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[14486.712711] sr 0:0:0:0: [sr0] Sense Key : Medium Error [current]
[14486.712721] Info fld=0xc1c74
[14486.712724] sr 0:0:0:0: [sr0] Add. Sense: Id CRC or ECC error
[14486.712734] end_request: I/O error, dev sr0, sector 3174864
[14486.712743] Buffer I/O error on device sr0, logical block 793716
[14496.417534] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[14496.417550] sr 0:0:0:0: [sr0] Sense Key : Medium Error [current]
[14496.417558] sr 0:0:0:0: [sr0] Add. Sense: No seek complete
[14496.417568] end_request: I/O error, dev sr0, sector 3174868
[14496.417577] Buffer I/O error on device sr0, logical block 793717
[14501.027392] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[14501.027407] sr 0:0:0:0: [sr0] Sense Key : Hardware Error [current]
[14501.027416] Info fld=0xc1c74
[14501.027419] sr 0:0:0:0: [sr0] Add. Sense: Track following error
[14501.027429] end_request: I/O error, dev sr0, sector 3174864
[14501.027437] Buffer I/O error on device sr0, logical block 793716
[14501.027452] Buffer I/O error on device sr0, logical block 793717
[14506.149807] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[14506.149822] sr 0:0:0:0: [sr0] Sense Key : Hardware Error [current]
[14506.149832] Info fld=0xc1c76
[14506.149835] sr 0:0:0:0: [sr0] Add. Sense: Track following error
[14506.149844] end_request: I/O error, dev sr0, sector 3174872
[14506.149853] Buffer I/O error on device sr0, logical block 793718
[14511.450046] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[14511.450062] sr 0:0:0:0: [sr0] Sense Key : Hardware Error [current]
[14511.450072] Info fld=0xc1c77
[14511.450075] sr 0:0:0:0: [sr0] Add. Sense: Track following error
[14511.450084] end_request: I/O error, dev sr0, sector 3174876
[14511.450092] Buffer I/O error on device sr0, logical block 793719
[14519.350094] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[14519.350108] sr 0:0:0:0: [sr0] Sense Key : Hardware Error [current]
[14519.350118] Info fld=0xc1c76
[14519.350121] sr 0:0:0:0: [sr0] Add. Sense: Track following error
[14519.350130] end_request: I/O error, dev sr0, sector 3174872
[14519.350138] Buffer I/O error on device sr0, logical block 793718
[14519.350153] Buffer I/O error on device sr0, logical block 793719
[14523.584653] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[14523.584668] sr 0:0:0:0: [sr0] Sense Key : Hardware Error [current]
[14523.584678] Info fld=0xc1c78
[14523.584681] sr 0:0:0:0: [sr0] Add. Sense: Track following error
[14523.584691] end_request: I/O error, dev sr0, sector 3174880
[14523.584700] Buffer I/O error on device sr0, logical block 793720

Good flix's no matter what...
-- 
Justin P. Mattock
