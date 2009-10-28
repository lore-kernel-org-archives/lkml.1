Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbZJ1Qtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbZJ1Qtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 12:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755122AbZJ1Qte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 12:49:34 -0400
Received: from web82006.mail.mud.yahoo.com ([66.163.178.250]:35322 "HELO
	web82006.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750870AbZJ1Qte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 12:49:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=yJFYRp8IEIVu/vSkgzchydZlhNGdd5CrdQsUQc+5O6UN+i6yIkENViIPr37/VJTHQWVVUDNcbiUvBUoaAMgN/PLsS+d/zneHki4Y7HbepSgGxRd5pXYMgps6M6Jx4iSkGZXpO5egJ4ihEYktmAbM2MRK2sMsFoklpWqE1ccrn40=;
Message-ID: <695608.9168.qm@web82006.mail.mud.yahoo.com>
X-YMail-OSG: ah5hMIIVM1nNHqSfo2tH5niHtKcn65N7Fh8YiyTpgMu_taAh0cXv4bpoxyaZVgQrFEkZJeo5tYt2Jq.aT2MT8IshLlKNwAWAnDZfB927Bh0GCyv7bZ5TjGy8SyllyPGQhnPZrYhHWymP7HEsuB9gt4Xgz.8hXoC9ZrubXX6MjngTdQO_C3qxpzmqu0EcBZPDh8uB63dxBUlbCUYvgtFJVzwfmigrCM0TK5cEqYZjutdoVtj8jfcsxQg3kbVypsqkySuGKdFF3zr7Ggud1OFLYgGKN0UdzIsCO5AgIUfVZxqeYFOd8H6ponQS9HtCJ7SLMjsz_rGTqeQXVZTTqOYQqKvPdWOMmn3ppJ8KWX2wI7rrdPsFPReHOGl3jKFRFWC9A9BALwRfWH8ovbEPv78m5hY8cLuJaKCjEIHdIIu19yeMzHYG8YcXmSju0oNgNyzzu64WEfvvMeBekDfXbpSvpukDrKi.mmNPet.CHvvrQvrJNcjUMfLegtPwxkQHD1S9v3GvC055gaKcS_Gt7Ox0RQX4l6mF3.MORHKNDdHnNhAK8J_LvlgwXfC2ejidR4sjNxhsaMBFb6lRbQ7RzSJDWTcdAn8uMGr7O8jxOQI6Bqyt.5prAeLabj_uQBeZF5TczV0NQdi47.9jtMknZ9jPDpOdNOE_uWA9YwZukcVrPHNFW5He2fIuyMcg.h6WvODUZsQoe8jS0UIeLiNG7U9BuhfABKA929KI0VnQ3opGetaiZ0rePmG48sVV2h8mkmrEwyiCG28RUW.NoPrs9G4e3nN0z3mzgCgJKEWuyEIrVgwUV57.sjWqcol9mFr7q5joHptXfNHCOS.FA5N9d4Z7KB0BEm8p9jhrG2Y0HSocWIIDqVRN1kxxtEUTJ0d.Ttco5T2UJDGoe8KjjtPHndd0mzkYjkvDX93zItBwQS3PcND8bLiyxmEG.dU0a0GsBrx_cN0DAqaG2ehbeKX4KpHqBiEE7mQQJBXBe7n8C4otyfKD6agLZsoG_QtNaELa4.tPd3OmiUC9am9eWfGb76CojboQpqChRuEkulCvKaNp7_FWqG27UcggkJhUIvjezeBcbm_dx9b.XB5_bAAUrcBv3O0tMY9ZFWa7DSNL3M4D0LItNTZN4r63yS3t2575sFtpeL9CeGIlxpIrpxiU__br037QiPeXqNhQAbxLew7OZcL.V2kb2HstdnR8DHZIITtkbnN0BKAwwLKTOG3CzzQLWnVsOQexH4O_He5SA8cAtWT3fxDph5C_FUNuIQi5o3dWe9mV.HgmenzbnOm2Zh7CJ7fyPJzPcaKjJXohZxmzxISEUAIaAxI1B9RUO0xZEwZZ4xXTRW3ZF48Q7yZGSRjApawdgWDX_SyV8pEgVwK7DM7jTuaWgl5D9isX.ew_85x.X3n5Q1jjz2PaA8ArX8_zttYKbHCzlN0wIMOJntQhKsyb6MF.A26l7EtnU0God_rH1D.oWeuCUPW9iHLpQz75GBOJaoTOTz0t_FdQK582wO1SKrb4mHNSb452j5tg8aeVUKqsWyce.kj8dsdFXpRRSpsh_PDLOxzTzhCO2Q7Bl7A2BVyH2CUL_f6A1StuE4c6CgDsXn_3uQRAw1nfmzwH5yOAkIl9qzvXMU7rgD88bETPc3qMsa16YgLefwu9L2Z3kz.YM.h1GDdEr1VQFodhn2oNYa2RQe.BqVAg1mCUqcK4jy_TIbGT.zt6KBy42AXbf8ZszK3MqV2WN_nYi00.ZzB6wAX069NCkhNamqBaTfqW_k1ehZtI4JZ4PgY5O.cX3jCLhu0266DxhyJGE8IHoG9MntoShQDD.uJJlkP1Hcb4uP6ZtIJ4uGapHOc-
X-Mailer: YahooMailClassic/7.0.14 YahooMailWebService/0.7.347.3
Date: Wed, 28 Oct 2009 09:49:38 -0700 (PDT)
From: Loan Agency <charlott-carter@sbcglobal.net>
Reply-To: loan_agency13@yahoo.com.hk
Subject: RE
To: undisclosed recipients:;
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Do you need loan to start up a business or to finance a
dieing business? Contact us for a loan @ 3%
