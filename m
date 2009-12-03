Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbZLCIYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbZLCIYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 03:24:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbZLCIYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 03:24:38 -0500
Received: from web83801.mail.sp1.yahoo.com ([69.147.85.65]:45912 "HELO
	web83801.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752659AbZLCIYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 03:24:38 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=1ngQlBBGtHo+PCYp+jG7s6hwlTVYe3cu2U6OSvE8mGG5FNsW6ljkwpy5t7/gOuRiS0rJC5E9yobREUQCHS+Vfwp3WlI2uCSgixcGWmWjc2J98xbGC+mgHtYXX2aS/Nx3GYG+inCSJACpKNw4bfcrucDntNETAg+hcINX4+COsx4=;
Message-ID: <683307.48765.qm@web83801.mail.sp1.yahoo.com>
X-YMail-OSG: ujEFbF4VM1mzyEu_iPseHwJRv8Phk3.bswOCCg7DVVW6As3F1eUxJGvFd1xiADdkQPjZN_466fDWcmu7eTbNSOiblTobi_D4BOb6QC3Jjtc1XM0qlnVQrjnadiqXPyqgSyarKOY5qZs0RRGcNy7hIRt_IB5tSjRNfMzC4kUISwcfJmJRlx5jIyp1tcIhYAKCk2GJAPvPlXdrZCkUCK6cD9hkJcYRdMx3EZ87awC93J4J6r9NL4xFm1YS8uipd7hp0D4WRbuc.Xbp0ksu5LXYpyWnHLqxX.xG9ceG4w3tvOQC4kTN3xnWYqgeEzRrIez7cKkM1uFwkDo9WRLy9GkKvXHwq.COuNf2y4fGB_kfTTMMTDAPER_.Waa.zKsOrHUIG5FS_dw04vP9zyCos6G_JKLOatTDRkn45xjEJIE5Ymspj3Bg9RFBYqlUf0d2UfTx.DJfKAlsfabgJC1r56jUyu6umhqjrtnDBToYeI6IS9dMKrRUmDaH3DYkOczlNrSC3BzCy..sh_IJfxQmkkUr1BRiRJxkwNye6P_IAgNiWTAp1MZv0aIjJm0.2Y3czXo2LqhT5xcuM8fsgjYS1Lf6AdI_ZXqRbNfnd99N4RiTRMtu3AA56LtioOkCtTuE5avInBJvXEvJoe9uwK4L8G0gNGLgn1thk0LAG2Q9jEcy60u8lFVHTpZY4NlJVTfkakljP8G.ReJfO8e9DUy7KDx8Pw7izEJlisedl9fusa7nnpfBq5k95x86MbJgCnbd4YPCSLfQ39SyFn9qIFKCeIq73X9dwOdwdDptp9LJqM1W64Lnv9i3B2HVHaodjy43Z5Zz5FIhFkpnj2EAku.hCLj6rx_Rie8wvAWEgMZlEsV82f.X4zfI9t_CGkx9Ynn3bI2EndfFQsDeHrGVVCxx1itNuNMqYjJyNCfgyjqUIDi87a9aNXbNpuQWCifVzE76USPcMMkwGIjhU8rl4WAFhgR8yKyE5pOmcrqWgsuxEPLCxwfzhN2l390So2eR8bSt5iT78f9WJbnoaNHAOCVTShTA8rscuVwZ06MBn2q0nLFAXXg4h5Qee3x1dF7ZpPwBri.cDgnWU1Mjy.8y9fmERs8xr7k7cbBnPISdLieFa2pMUJIb0_VnYw0rn8fn_7w3v1HfFkpcr0fkVF.1HwCNdBlQ3uMsn04CVgPOdBZD2GEbF5UU8queIv6dWWRoAW_q1xuzwiNkvUL8kRwpPCwSbY5iGvBQ6XG0bnOFYawKMXEMNBIp4XxlsGcMUkNrS5G2vsRdDrAr3ZywDdxjmuicRDx.YIQI_rFGQwEQ6UeckRZXkM4MYEreXHIfIUFXF9oFd82LSkwjIMGOrRpVqT.DNvwFiQu7PzI24mbKaFd6O9BpvYhTpXl2PFgPet_aOIhC9UAt9f5A2P1Md7ce7cCHiOSZTbv1uyPYUJUoy_zHNAmBuc0.jTICRm6pxtjwLnd7EdguFienqeba3RC_Vr2fAnhd0SmjkT9D2vmuWtUsrpTNih1Fw4NnkhxNOPuHghtyBUFfQYze37oPFEGadfQJQWrBDioiiiINBiXDJ3qUqJQ7crlBwhtt2111MgOBXyEr6fFdwdbViuOqi9O_PJbiPtkWws1ww8GNnFh7ljayy1bT6rHPxnxR0_SVrhkjMXlUS_SceHB.fu6n7Tu58GT.wL.BJvinpU1ty9JyClna2JMrqJN3FZr2TjKSztKAP7oWXnZdNdJyIBuBLm_emnTV_qWJwfcUTOhjGUBkxlEpjN_Ckd4CT3dUeirGO7MMUgYn8ciAiTxBAY87zDj48iQ.GEDDNqbcdonyE74RgzOra8DfeQkW8DuHkBKwgb9cjC_4uMoJ.VjJ80RZ.ov0K1iTLaOVI2T4LYZr4.UvyoQTjWboSU0Sql154lKsP4leFUeQwNwIAMri9aF5rSwsEb4pWjxJPB3Ve3YHrmG62CaXj7YbqWAPpPa2Eqw0ZDvFz_Jr9A.q1bipDBrpoxbiqLsdeHZc0XCZcpc2VyDlG0XNm9T0sR!
 2ADdA4z5Egi4AY0oQRcGrqcgrkyrNZ6e0J9d.FoLztZ6WikSJtxMnUL7HbJFrvehkp2LGPwv_.E_qr2asXv65CotfVw5.apauyRVAjGqP4_rw3Y6NlkiNQIIJdcX3lxqh9uTIiknkAgNJ83I9FZX0m.4YH1lvxv3n6gffsjreI9hWcMG_qV1hU6xL9QxY4RFvGzr9FCXfT.Mql0tUtZaaLdcHYvOYvKUg6wjY2l.v9QUKDbUsnAPEPWwOWTIrpqQXE0H.UXb
X-Mailer: YahooMailClassic/8.1.6 YahooMailWebService/0.8.100.260964
Date: Thu, 3 Dec 2009 00:24:43 -0800 (PST)
From: Mercedes Benz <0otraviso0@sbcglobal.net>
Reply-To: edward.howell909@hotmail.com
Subject: This is to inform you that 950,000.00 GBP has been awarded to you in our Mercedes Benz Xmas Splash send your details
To: undisclosed recipients:;
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Name......
Address......
