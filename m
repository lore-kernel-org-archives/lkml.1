Return-Path: <linux-kernel-owner+w=401wt.eu-S1761249AbXK1RWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761249AbXK1RWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 12:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758848AbXK1RWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 12:22:40 -0500
Received: from ro-out-1112.google.com ([72.14.202.183]:53376 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757109AbXK1RWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 12:22:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=bRnQMZfOgMGqgyihOIMxBnRIrEH5C2x4LjNU7MgolTylE04+1CpM47m99jXYneVcP8sngypVAn2qpCNWsynvKFSjB/aCqA1yD2055e1RgKJ+3CvxCQZfu4kkmJyh2yMm6UHj/2zIFjfulT0C/1I0wyy0j8kj5EJ9Rcbxcqmv/CM=
Date: Thu, 29 Nov 2007 00:22:17 +0700
From: Riki Oktarianto <rkoktarianto@gmail.com>
To: Nicolas Boichat <nicolas@boichat.ch>
Cc: linux-kernel@vger.kernel.org, mactel-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH] applesmc - sensors set for MacBook2, try 2
Message-ID: <20071128172217.GA15776@ceren>
References: <20071128171759.GA15684@ceren>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128171759.GA15684@ceren>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 12:17:59AM +0700, Riki Oktarianto wrote:
> Add sensors set for MacBook2, from register dump on a mid-2007 MacBook2.
> 
> --
> 
> Signed-off-by: Riki Oktarianto <rkoktarianto@gmail.com>
> 
> --- linux-2.6.24-rc3.orig/drivers/hwmon/applesmc.c
> +++ linux-2.6.24-rc3/drivers/hwmon/applesmc.c

This is the register dump:

  0: #KEY  4 ui32 00 00 00 e2 
  1: +LKS  1 flag 07 
  2: ACID  8 ch8* ba be 3c 45 c0 03 10 43 
  3: ALSC 16 {alc 01 92 00 96 01 4a 00 02 00 01 00 64 2e fd 00 00 
  4: AUPO  1  ui8 00 
  5: B0AC  2 si16 00 00 
  6: B0AP  1 flag 00 
  7: B0AV  2 ui16 00 00 
  8: B0Al  2 ui16 ff ff 
  9: B0Am  1  ui8 00 
 10: B0BI  1  ui8 00 
 11: B0FC  2 ui16 00 00 
 12: B0LI  2 ui16 0e 10 
 13: B0RI  2 ui16 00 00 
 14: B0RM  2 ui16 00 00 
 15: B0St  2 ui16 00 00 
 16: BATP  1 flag 00 
hexdump: key_at_index_data: Input/output error
 17: BISE  1  ui8 
 18: BNum  1  ui8 01 
 19: BRSC  2 ui16 00 00 
 20: BSDC  1  ui8 00 
 21: BSIn  1  ui8 42 
 22: CLK!  1  ui8 00 
 23: CLKC 10 {clc 00 00 0e 10 00 00 0e 10 19 8c 
 24: CLKH  8 {clh 00 00 00 00 00 00 00 00 
 25: CLKS  2 fp1f 80 00 
 26: CLKT  4 ui32 00 00 36 e8 
 27: CRCB  4 ui32 c5 12 fc 40 
hexdump: key_at_index_data: Input/output error
 28: CRCU  4 ui32 
cat: key_at_index_name: Invalid argument
cat: key_at_index_data_length: Invalid argument
cat: key_at_index_type: Invalid argument
hexdump: key_at_index_data: Invalid argument
 29:       0      
cat: key_at_index_name: Invalid argument
cat: key_at_index_data_length: Invalid argument
 30:       0 ui32 01 b0 17 00 
 31: EPCV  2 ui16 00 01 
 32: EPMA  4 ch8* 00 00 e0 80 
 33: EPMI  1  ui8 00 
 34: EPUF  1 flag 01 
 35: EPUI  4 ui32 01 b0 00 04 
 36: EPUV  2 ui16 00 01 
 37: EVCT  2 ui16 00 00 
hexdump: key_at_index_data: Input/output error
 38: EVMD  4 ui32 
 39: EVRD 32 ch8* f6 06 03 00 00 00 00 19 1e 05 38 00 01 00 00 19 73 00 00 00 01 00 00 19 00 00 00 00 00 00 00 00 
 40: F0Ac  2 fpe2 1c 2e 
 41: F0ID 16 {fds 00 00 0a 00 45 78 68 61 75 73 74 20 20 00 00 00 
 42: F0Mn  2 fpe2 1c 20 
 43: F0Mt  2 ui16 00 00 
 44: F0Mx  2 fpe2 60 e0 
 45: F0Sf  2 fpe2 12 c0 
 46: F0Tg  2 fpe2 1c 20 
 47: FNum  1  ui8 01 
hexdump: key_at_index_data: Input/output error
 48: FPhz  2  i16 
 49: FS!   2 ui16 00 00 
 50: HDBS  1  ui8 01 
 51: HDST  4 ui16 00 00 00 00 
 52: HDSW  4 ui32 00 00 00 00 
 53: HIBW  1 flag 00 
 54: IC0C  2 fp6a 14 37 
 55: IC0c  2 ui16 24 40 
 56: ID0R  2 fp3d 1e 9d 
 57: ID0r  2 ui16 22 80 
 58: IN0R  2 fp6a 00 a8 
 59: IN0r  2 ui16 08 00 
 60: IN1R  2 fp6a 03 b0 
 61: IN1r  2 ui16 10 00 
 62: IP0R  2 fp4c 00 93 
 63: IP0r  2 ui16 00 80 
hexdump: key_at_index_data: Input/output error
 64: LAcN  1  ui8 
hexdump: key_at_index_data: Input/output error
 65: LAtN  2 ui16 
 66: LCCN  1  ui8 07 
 67: LCCQ  1  ui8 07 
 68: LCKA  1  ui8 98 
 69: LCSA  1  ui8 00 
 70: LCTN  1  ui8 01 
 71: LCTQ  1  ui8 02 
hexdump: key_at_index_data: Input/output error
 72: LDSB  2 fp1f 
hexdump: key_at_index_data: Input/output error
 73: LDSP  1 flag 
 74: LS!   1  ui8 00 
 75: LSCF 10 {lsc 0b b8 02 3a 80 00 01 02 00 01 
 76: LSDD  8 {lsd 00 02 00 03 00 03 00 19 
 77: LSDU  8 {lsd 00 03 00 02 00 14 00 03 
 78: LSFD  6 {lsf 2e e0 00 04 00 17 
 79: LSFU  6 {lsf ff ff 01 90 03 20 
 80: LSLB  2 {pwm ff ff 
 81: LSLF  2 {pwm 00 00 
 82: LSLN  2 {pwm ff ff 
 83: LSOF  1 flag 01 
hexdump: key_at_index_data: Input/output error
 84: LSOO  1 flag 
 85: LSPV  2 {pwm 00 00 
hexdump: key_at_index_data: Input/output error
 86: LSRB  1 flag 
hexdump: key_at_index_data: Input/output error
 87: LSSB  2 {lso 
 88: LSSE  1 flag 01 
hexdump: key_at_index_data: Input/output error
 89: LSSS  2 {lso 
 90: LSSV  2 ui16 ff ff 
hexdump: key_at_index_data: Input/output error
 91: LSUP  1  ui8 
 92: MACA  4 ui32 00 00 00 00 
 93: MACM  1 flag 01 
 94: MACR 32 ch8* 63 68 38 2a 90 00 00 19 1e 05 38 00 01 00 00 19 73 00 00 00 01 00 00 19 00 00 00 00 00 00 00 00 
 95: MOCF  2 ui16 86 00 
 96: MOCN  2 ui16 e0 f8 
 97: MOHD  1  ui8 14 
 98: MOHT  2 sp78 01 c0 
 99: MOLD  1  ui8 14 
100: MOLT  2 sp78 00 60 
101: MOST  2 ui16 80 03 
102: MO_X  2 sp78 ff f7 
103: MO_Y  2 sp78 ff ef 
104: MO_Z  2 sp78 01 04 
hexdump: key_at_index_data: Input/output error
105: MSAL  1  si8 
106: MSAc  2 fp88 00 00 
107: MSAg  2 fp88 00 00 
108: MSAm  2 fp88 00 00 
109: MSBC  2 ui16 00 00 
110: MSBP  2 ui16 00 00 
111: MSBc  2 ui16 00 00 
112: MSBp  2 ui16 00 00 
113: MSC0  2 ui16 3a 11 
114: MSC1  2 ui16 00 69 
115: MSC2  2 ui16 00 69 
116: MSC3  2 ui16 00 69 
117: MSCP  2 ui16 00 08 
118: MSCR  1 ui18 01 
hexdump: key_at_index_data: Input/output error
119: MSCS  1  ui8 
120: MSCT  1  ui8 04 
121: MSCa  2 ui16 04 00 
122: MSCb  2 ui16 04 00 
123: MSCc  2 ui16 04 00 
124: MSCd  2 ui16 04 00 
125: MSCl  2 ui16 00 08 
126: MSCm  2 ui16 00 08 
127: MSCn  2 ui16 00 08 
128: MSCo  2 ui16 00 08 
hexdump: key_at_index_data: Input/output error
129: MSDW  1 flag 
130: MSLD  1  ui8 00 
131: MSPA  1 fp88 00 
132: MSPS  1 {msp 00 
133: MSSD  1  si8 00 
134: MSSP  1  si8 00 
135: MSSS  1 {mss 00 
136: MSTM  1  ui8 01 
137: MSTc  1  ui8 00 
138: MSTg  1  ui8 00 
139: MSTm  1  ui8 00 
hexdump: key_at_index_data: Input/output error
140: MSWR  1  ui8 
141: NATJ  1  ui8 00 
142: NATi  2 ui16 00 00 
hexdump: key_at_index_data: Input/output error
143: NTOK  1  ui8 
144: ONMI  1  ui8 00 
145: PC0C  2 fp88 03 eb 
146: PD0R  2 fp88 0f 34 
147: PHPC  2 fp88 05 26 
148: PN0R  2 fp88 01 3c 
149: PP0R  2 fp88 00 73 
150: PTHC  2 fp88 1a 55 
151: RBr   8 ch8* 6d 34 32 62 00 00 00 00 
152: REV   6 {rev 01 17 0f 00 00 00 
153: RMde  1 byte 41 
154: RPlt  8 ch8* 6d 34 32 62 00 00 00 00 
155: RSvn  4 ui32 00 00 33 53 
156: RVBF  6 {rev 01 17 0f 00 00 00 
157: RVUF  6 {rev 01 17 0f 00 00 00 
hexdump: key_at_index_data: Input/output error
158: SAS!  4 ui32 
hexdump: key_at_index_data: Input/output error
159: SDRd  2 ui16 
hexdump: key_at_index_data: Input/output error
160: SIS!  2 ui16 
161: SM0x  2 ui16 7e 00 
162: SM0y  2 ui16 83 c0 
163: SM0z  2 ui16 4b c0 
164: SPHS  1  ui8 01 
165: SPHT  1  ui8 03 
hexdump: key_at_index_data: Input/output error
166: SPS!  2 ui16 
167: TB0T  2 sp78 80 00 
168: TC0D  2 sp78 3e 00 
169: TC0P  2 sp78 3a 00 
170: TM0P  2 sp78 33 80 
171: TN0P  2 sp78 37 20 
172: TN1P  2 sp78 37 00 
173: TTF0  2 sp78 39 40 
174: Th0H  2 sp78 39 a0 
175: Th0S  2 sp78 39 5b 
176: Th1H  2 sp78 39 20 
177: VC0C  2 fp2e 35 92 
178: VC0c  2 ui16 49 00 
179: VP0R  2 fp4c ca 48 
180: VP0r  2 ui16 a3 40 
181: iC0C  2 ui16 03 00 
182: iC0c  2 ui16 01 00 
183: iD0R  2 ui16 03 00 
184: iD0r  2 ui16 01 00 
185: iN0R  2 ui16 03 00 
186: iN0r  2 ui16 01 00 
187: iN1R  2 ui16 03 00 
188: iN1r  2 ui16 01 00 
189: iP0R  2 ui16 03 00 
190: iP0r  2 ui16 01 00 
191: pC0C  2 {sds 03 00 
192: pD0R  2 {sds 03 00 
193: pN0R  2 {sds 03 00 
194: pP0R  2 {sds 03 00 
195: tA0P  2 {sds 01 00 
196: tB0T  2 {sds 01 00 
197: tC0D  2 {sds 01 00 
198: tC0P  2 {sds 01 00 
199: tM0P  2 {sds 01 00 
200: tN0P  2 {sds 01 01 
201: tN1P  2 {sds 01 00 
202: th0H  2 {sds 01 00 
203: th1H  2 {sds 01 01 
204: ts0P  2 {sds 01 00 
205: vC0C  2 {sds 03 00 
206: vC0c  2 {sds 01 00 
207: vP0R  2 {sds 03 00 
208: vP0r  2 {sds 01 00 
hexdump: key_at_index_data: Input/output error
209: zDBG  1  ui8 
hexdump: key_at_index_data: Input/output error
210: zSCI  1  ui8 
211: {clc  3      00 01 db 
212: {clf  3      00 01 df 
213: {clh  3      00 01 db 
214: {fds  3      00 01 db 
215: {lsc  3      00 01 dd 
216: {lsd  3      00 01 db 
217: {lsf  3      00 01 db 
218: {lsm  3      00 01 dd 
219: {lso  3      00 01 dd 
220: {lss  3      00 01 dd 
221: {msp  3      00 01 de 
222: {mss  3      00 01 de 
223: {pwm  3      00 01 dc 
224: {rev  3      00 01 df 
225: {sds  3      00 01 dc 
