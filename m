Return-Path: <linux-kernel-owner+w=401wt.eu-S1762173AbZLKBbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762173AbZLKBbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 20:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762155AbZLKBbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 20:31:31 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:49642 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762154AbZLKBba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 20:31:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=D/BsBP0M33xZWvOCfXoRduVcOuuCc8iJcADGMEkvlp1k3mv0Yz519XvLH/gnrlbNgz
         uNy4ONao+jMGXWEzb5uoXa4+9rovrR9J4ZhfDz4hvcWspU3YKYW40qOb3t26VFp2IWpR
         K2ZeKhsmu5h5wmaZorXbO3g0MPx8EvRUaFhAw=
MIME-Version: 1.0
In-Reply-To: <200912101549.52797.isdn@linux-pingi.de>
References: <6304b52b0912092004t646569bdm2a6bbc9bb2440aba@mail.gmail.com>
	 <200912101549.52797.isdn@linux-pingi.de>
Date: Fri, 11 Dec 2009 09:31:36 +0800
Message-ID: <6304b52b0912101731q5870de82qf8ca00846db90e1@mail.gmail.com>
Subject: Re: [PATCH]about eicon: array subscript is above array bounds
From: Jerry Leo <jerryleo860202@gmail.com>
To: isdn@linux-pingi.de
Cc: linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
       i4ldeveloper@listserv.isdn4linux.de, Armin Schindler <armin@melware.de>
Content-Type: multipart/mixed; boundary=000e0cd11bd47e369b047a69e2a9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd11bd47e369b047a69e2a9
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Okay,

       this is the patch i have tested. :)

diff --git a/linux-2.6/drivers/isdn/hardware/eicon/divacapi.h.orig
b/linux-2.6/drivers/isdn/hardware/eicon/divacapi.h
index 9f5b680..d9462f7 100644
--- a/linux-2.6/drivers/isdn/hardware/eicon/divacapi.h.orig
+++ b/linux-2.6/drivers/isdn/hardware/eicon/divacapi.h
@@ -445,7 +445,7 @@ struct _DIVA_CAPI_ADAPTER {
 #define CAPI_MAX_HEAD_LINE_SPACE        89
 #define CAPI_MAX_DATE_TIME_LENGTH       18

-#define T30_MAX_STATION_ID_LENGTH       20
+#define T30_MAX_STATION_ID_LENGTH       30
 #define T30_MAX_SUBADDRESS_LENGTH       20
 #define T30_MAX_PASSWORD_LENGTH         20


thanks,:)


best regards!
                        JerryLeo




2009/12/10 Karsten Keil <isdn@linux-pingi.de>:
> On Donnerstag, 10. Dezember 2009 05:04:35 Jerry Leo wrote:
>> Hi, Karsten Keil,
>>
>> =A0 =A0 =A0 =A0 When i compile eicon,there have some waning look like th=
is:
>
> This looks wrong, but I do not know this part so well.
>
> Armin ?
>
>>
>> =A0 =A0 =A0 =A0 =A0 =A0CC [M] =A0drivers/isdn/hardware/eicon/message.o
>> drivers/isdn/hardware/eicon/message.c: In function =91add_b23=92:
>> drivers/isdn/hardware/eicon/message.c:8426: warning: array subscript
>> is above array bounds
>> drivers/isdn/hardware/eicon/message.c:8427: warning: array subscript
>> is above array bounds
>> drivers/isdn/hardware/eicon/message.c:8434: warning: array subscript
>> is above array bounds
>> drivers/isdn/hardware/eicon/message.c:8435: warning: array subscript
>> is above array bounds
>> drivers/isdn/hardware/eicon/message.c:8436: warning: array subscript
>> is above array bounds
>> drivers/isdn/hardware/eicon/message.c:8447: warning: array subscript
>> is above array bounds
>>
>> I think the array is short then be used,because the array's max length
>> is 20, then it will use long than this, the code is in
>> "drivers/isdn/hardware/eicon/divacapi.h" 1360L, 50994C =A0:
>>
>>
>> #define T30_MAX_STATION_ID_LENGTH =A0 =A0 =A0 20
>> #define T30_MAX_SUBADDRESS_LENGTH =A0 =A0 =A0 20
>> #define T30_MAX_PASSWORD_LENGTH =A0 =A0 =A0 =A0 20
>>
>> typedef struct t30_info_s T30_INFO;
>> struct t30_info_s {
>> =A0 byte =A0 =A0 =A0 =A0 =A0code;
>> =A0 byte =A0 =A0 =A0 =A0 =A0rate_div_2400;
>> =A0 byte =A0 =A0 =A0 =A0 =A0resolution;
>> =A0 byte =A0 =A0 =A0 =A0 =A0data_format;
>> =A0 byte =A0 =A0 =A0 =A0 =A0pages_low;
>> =A0 byte =A0 =A0 =A0 =A0 =A0pages_high;
>> =A0 byte =A0 =A0 =A0 =A0 =A0operating_mode;
>> =A0 byte =A0 =A0 =A0 =A0 =A0control_bits_low;
>> =A0 byte =A0 =A0 =A0 =A0 =A0control_bits_high;
>> =A0 byte =A0 =A0 =A0 =A0 =A0feature_bits_low;
>> =A0 byte =A0 =A0 =A0 =A0 =A0feature_bits_high;
>> =A0 byte =A0 =A0 =A0 =A0 =A0recording_properties;
>> =A0 byte =A0 =A0 =A0 =A0 =A0universal_6;
>> =A0 byte =A0 =A0 =A0 =A0 =A0universal_7;
>> =A0 byte =A0 =A0 =A0 =A0 =A0station_id_len;
>> =A0 byte =A0 =A0 =A0 =A0 =A0head_line_len;
>> =A0 byte =A0 =A0 =A0 =A0 =A0station_id[T30_MAX_STATION_ID_LENGTH];
>> /* byte =A0 =A0 =A0 =A0 =A0head_line[]; =A0 =A0 =A0*/
>> /* byte =A0 =A0 =A0 =A0 =A0sub_sep_length; =A0 */
>> /* byte =A0 =A0 =A0 =A0 =A0sub_sep_field[]; =A0*/
>> /* byte =A0 =A0 =A0 =A0 =A0pwd_length; =A0 =A0 =A0 */
>> /* byte =A0 =A0 =A0 =A0 =A0pwd_field[]; =A0 =A0 =A0*/
>> /* byte =A0 =A0 =A0 =A0 =A0nsf_info_length; =A0 */
>> /* byte =A0 =A0 =A0 =A0 =A0nsf_info_field[]; =A0*/
>> };
>>
>> "drivers/isdn/hardware/eicon/message.c" 15071L, 487328C
>>
>> =A0 =A0 =A0 =A0 if (pos !=3D 0)
>> =A0 =A0 =A0 =A0 {
>> =A0 =A0 =A0 =A0 =A0 if (CAPI_MAX_DATE_TIME_LENGTH + 2 +
>> b3_config_parms[3].length > CAPI_MAX_HEAD_LINE_SPACE)
>> =A0 =A0 =A0 =A0 =A0 =A0 pos =3D 0;
>> =A0 =A0 =A0 =A0 =A0 else
>> =A0 =A0 =A0 =A0 =A0 {
>> =A0 =A0 =A0 =A0 =A0 =A0 ((T30_INFO *)&nlc[1])->station_id[20 + pos++] =
=3D ' ';
>> =A0 =A0 =A0 =A0 =A0 =A0 ((T30_INFO *)&nlc[1])->station_id[20 + pos++] =
=3D ' ';
>> =A0 =A0 =A0 =A0 =A0 =A0 len =3D (byte)b3_config_parms[2].length;
>> =A0 =A0 =A0 =A0 =A0 =A0 if (len > 20)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D 20;
>> =A0 =A0 =A0 =A0 =A0 =A0 if (CAPI_MAX_DATE_TIME_LENGTH + 2 + len + 2 +
>> b3_config_parms[3].length <=3D CAPI_MAX_HEAD_LINE_SPACE)
>> =A0 =A0 =A0 =A0 =A0 =A0 {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < len; i++)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((T30_INFO *)&nlc[1])->station_id[20 + p=
os++] =3D ((byte
>> =A0 *)b3_config_parms[2].info)[1+i];
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((T30_INFO *)&nlc[1])->station_id[20 + pos++=
] =3D ' ';
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((T30_INFO *)&nlc[1])->station_id[20 + pos++=
] =3D ' ';
>> =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 }
>>
>>
>>
>> can this patch commit?
>>
>
> Wrong fileorder, this is a reverse patch.
> But I =A0think the code should be fixed.
>
>>
>> diff -up linux-2.6/drivers/isdn/hardware/eicon/divacapi.h
>> linux-2.6/drivers/isdn/hardware/eicon/divacapi.h.orig
>> --- linux-2.6/drivers/isdn/hardware/eicon/divacapi.h =A02009-12-10
>> 12:02:46.000000000 +0800
>> +++ linux-2.6/drivers/isdn/hardware/eicon/divacapi.h.orig =A0 =A0 2009-1=
2-10
>> 11:04:07.000000000 +0800
>> @@ -445,7 +445,7 @@ struct _DIVA_CAPI_ADAPTER {
>> =A0#define CAPI_MAX_HEAD_LINE_SPACE =A0 =A0 =A0 =A089
>> =A0#define CAPI_MAX_DATE_TIME_LENGTH =A0 =A0 =A0 18
>>
>> -#define T30_MAX_STATION_ID_LENGTH =A0 =A0 =A0 30
>> +#define T30_MAX_STATION_ID_LENGTH =A0 =A0 =A0 20
>> =A0#define T30_MAX_SUBADDRESS_LENGTH =A0 =A0 =A0 20
>> =A0#define T30_MAX_PASSWORD_LENGTH =A0 =A0 =A0 =A0 20
>>
>

--000e0cd11bd47e369b047a69e2a9
Content-Type: application/octet-stream; name=patch
Content-Disposition: attachment; filename=patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g32a76i20

ZGlmZiAtLWdpdCBhL2xpbnV4LTIuNi9kcml2ZXJzL2lzZG4vaGFyZHdhcmUvZWljb24vZGl2YWNh
cGkuaC5vcmlnIGIvbGludXgtMi42L2RyaXZlcnMvaXNkbi9oYXJkd2FyZS9laWNvbi9kaXZhY2Fw
aS5oCmluZGV4IDlmNWI2ODAuLmQ5NDYyZjcgMTAwNjQ0Ci0tLSBhL2xpbnV4LTIuNi9kcml2ZXJz
L2lzZG4vaGFyZHdhcmUvZWljb24vZGl2YWNhcGkuaC5vcmlnCisrKyBiL2xpbnV4LTIuNi9kcml2
ZXJzL2lzZG4vaGFyZHdhcmUvZWljb24vZGl2YWNhcGkuaApAQCAtNDQ1LDcgKzQ0NSw3IEBAIHN0
cnVjdCBfRElWQV9DQVBJX0FEQVBURVIgewogI2RlZmluZSBDQVBJX01BWF9IRUFEX0xJTkVfU1BB
Q0UgICAgICAgIDg5CiAjZGVmaW5lIENBUElfTUFYX0RBVEVfVElNRV9MRU5HVEggICAgICAgMTgK
IAotI2RlZmluZSBUMzBfTUFYX1NUQVRJT05fSURfTEVOR1RIICAgICAgIDIwCisjZGVmaW5lIFQz
MF9NQVhfU1RBVElPTl9JRF9MRU5HVEggICAgICAgMzAKICNkZWZpbmUgVDMwX01BWF9TVUJBRERS
RVNTX0xFTkdUSCAgICAgICAyMAogI2RlZmluZSBUMzBfTUFYX1BBU1NXT1JEX0xFTkdUSCAgICAg
ICAgIDIwCiAK
--000e0cd11bd47e369b047a69e2a9--
