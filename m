Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352Ab0AFEkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab0AFEkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 23:40:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755132Ab0AFEkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 23:40:22 -0500
Received: from n6.bullet.mail.gq1.yahoo.com ([98.137.27.133]:22309 "HELO
	n6.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754764Ab0AFEkW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 23:40:22 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 624390.7249.bm@omp127.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=3ysDorFfXYrC4ddBNTY0QV1yaB22EeSDO8fYuB4LuFRet1WbxU9syf+/NbL/oJKgwMvo/v2xeCzqmQ4EWNL9OU1GsgsT7qpaAuY4798TLMWohu+MDnbCGZwDZHtEk8aF7PHW8UmPEXMsGE5/9qamU8gvBzCx0WqHfaw93ryHayE=;
Message-ID: <374673.77534.qm@web180305.mail.gq1.yahoo.com>
X-YMail-OSG: lraExGgVM1lXKTjWkNPBB804CNZ02XhkYyCH5KnGyUJ9C9.DMjZ.o0sN8tnl4uTErjjxzpyPmFG.OGz8.0AfxZ09CVITpse1ZGtDQ0a0AUspdR0XgUfKjbAyrW8Z8b6k1DbOQm9PVXsBsbLItJdSkDevQJZ.cje5AAUpj8G2Ytr7lPW.ASO9MtcYKjgHqUnXTp7ykE3QC6WbgBMoKcj1mmfrjjnlEbtE8aegGNvVDmZeujm1o3x2hURRhAnnkEO.GxGto5A8O3Y.0GKDXmHe_F1Z8qvET0KACQPA9rMinpyy3nEORjaHfY2TfNNcaW9HhMiGZ9jsCNJHQytFHdivbiCF.iTiPeKhEzssR_KqDtHi9MKb54DpqwS8HPGBuXeDszbPs1PJb5wllY7MUxStV1wDPn25_bCjF9wbAQeyIB3HyfThsSwiQYanWbXkvma7Llst_3x12euLInkaGDLsZeT4IVSMgYzGzA7c33cVO3HGNiomDfex0n7hLoH.5pIZl8DXZrVcbczi6zWVw4.jSAlYnTdEogVlWrS_fBwRbHeSPrt.3Oh72N9yYz.49S.bVJgAZ0FzeDinp4u1RQxvVrWx1m7SfOzbQUK79GvKIET3f_pCXJhbcMO8orVAosgLbGoPdq6LCWHTnpy8pseYWfd4Iip.BiaWZj.Ij57XvzpQHz2.KxX3SaFyOQP6L8OOQErTb712c6AMGVhKKkmVwRTwOR.Xi_2_vSzMnDvlz7QaRlCggMUJNcPygE_tJxPUhN_8qYdIMSCzDzxKuCtdW7ZOvMrgaVzEysQLCeCXOo34gGqUvU1XrsipQhnStNGV5nzL2UsJOQlnsl4E3VBfbpSYwnomOgoVfXduQuPpHUxmM5xhzha1_sOYlhCYwa7N4pmcSp8KKGv9.pOzIqSWGrRVKAp_YzL7NBMDGJJO6byYmFPyF1N8IctLNu6U1k8rLNszgBg_x9jbwJJcBdIvRxdlMKDqhGjrBM9vWhOoLE09UnmtQNaODJhbkcb1aGR1mh1ipYbjdyBX89FUqJMvfe_zQBdgOVvAj984ZI4Gq8JmME15qV8HuAExqfbT0gKwvYh51ZmhNf.OfHMZAhr.6_ovYVKc7ICr.nTKRQUEYaaVjY9bQRi711QZ6XZWA2Mt9XdxC9dFiMdtehjlaQcN1cIKLTP_whjKkpFizm7m6uBlG4kLtHM_JAgT5mjTeQpPlKLyQ5wu68q7wPIjPV21j0Rernxtw_xDW34XqtzbI74aedPHw7TvZQAViXJoVX5tjfDGjhYLmdLL_XHuMdHzrbkJ1QR_YHZv5rxyYS6LU12r196BguvqXL9ty1ZWBuI38eT5P0lfvoKJs2w4z8X_sHqDrJ401tT7N.taCHxwn0Woagon3plmRQ8kfk0vHWi6L5a_6hGsoxk8DrbhLdF3T5mrBhDPufHPT5TM0E_UzmEdYftYrMQpDkyMeIDZNo9YTFGGw1uw8jDCfKNadvmDPZuW06H4YVkdCy92vJaDQX3qEkuC4HPHIdIo3jt3lptOQG3DsHmx9JD5a9kxnWWHzymtKVh.BZ16OAxcV6RK10Yn_TaaJ8Gla887zTarwl8F72mzikKm7TV7jXTos.l1tBveP7XNOgSKn753.kO9wly4DUaRA_.a7zW8h36TH0c61emsZRB0cP81izq4fVkB064YCXwsEaqmn4aOzpR17qGNBe.UTcBkMQlp_ky4ecbQh3fwyBTwzXPr4gNXQRkUyhblP9B97kjNImOPMMYVU91KplqZPgeD5zaceXRxdXAOaGry32pG2af6KVqui19Djrq8u.8XCjrV03IadYMc3E9syUyE_CGfrZsnxCGpax_tIqhs.YfQvAxdJMX.BW3QmNP7BJUHJZgQvTPuQkvUFcnBPIukvrnWWdBr1rX3SBk3Y26QAfaevqCEYCpzxBHUbJN_7gnrljSaEnvTnRb7cUIA9lkqvf_GId2YCSA3ZNEm6TvISYKKxy6_9gBtdqcJW083z6PLS2eyG1uxw7C9Zo!
 QMA.qVHkaDcAbGhSpdl_bqmqB6dnZzEv.p7gHbvJ9cR66uA0Jhl5mMtT_miwZnCVzDBGoN3h60ENzBxOJ6ycl7l7tr8xM.BXkX.2ieQ1xcW7rD0Nm.qdvlKJigi9_.1CZLx.nfZixEMIGPVw5B4eC.7hN4PBbEznJuOC0YITbEKItpPUgTKb76pE5mWvrZhiSj.9DYgKp.O4KjSLUq3AJ0rzqPmr2.d0wbjLXNw1h_uTUab3aoPGfD45FspEyBKAqVrY8rgB
X-Mailer: YahooMailClassic/9.0.20 YahooMailWebService/0.8.100.260964
Date: Tue, 5 Jan 2010 20:40:19 -0800 (PST)
From: Irish News Centre <updatecentre@sbcglobal.net>
Reply-To: inc.il@w.cn
Subject: Notification
To: undisclosed recipients:;
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You Won £750,000.00
send,adress,name and occupation

