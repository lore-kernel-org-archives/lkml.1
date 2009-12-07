Return-Path: <linux-kernel-owner+w=401wt.eu-S934709AbZLGWTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934709AbZLGWTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 17:19:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934616AbZLGWTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 17:19:15 -0500
Received: from web81605.mail.mud.yahoo.com ([68.142.199.157]:33018 "HELO
	web81605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934568AbZLGWTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 17:19:14 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=bGHDck0kMlrHD4oLG73iP5fvyvdcIGWBXnNRw9F9RZG38gc+5jVZe0g8zzA9ooHGNpkmCyJWEiCv4cJoigGye4b/78k6IUVQ8U1UmgEd3RQmff96d+W+P+KrBgTecdLqfNH1S0cuGh+43hZ+XbwrkSSSl2JOF8zQMs5OWEhHjg8=;
Message-ID: <91559.91067.qm@web81605.mail.mud.yahoo.com>
X-YMail-OSG: jO6v5aIVM1n8Kzg9GttDNIntGwrrBlM_ZSZfeXU_4Q6mPwzEObBAJj74FITV2vcU0Y4CpKUuO8Ni8tNnUPunDFaplZev9BRqi2PumzGA4SHpA3eaF1t3m2DEmhZaO5harq22eVi2ox43wmrtbOrL_P5OSkWApcJe9bX51pCpoxvqsJzE8wGnMvXlMWcmBcsR2hA2KlErwBV64pj0Wf4EyQmDe.P84ICwoEsZTzxaMH7m6JvZcRlgsdi9hGRfM6DoZGO83oEYVyomonEB78bT1Si1m5FWLkwnWcN7gIHT672P.QgbxWjSTb.TE_Nz0Pp7Gf_.8nvHHAVpvSsSKEpsrq37vCaAW6q.hmV8SIwcWVOmKSkRsQ5PdYrJy4030A9R35bBofvf2TyODhjoiiRJod66F_RnXHoYfdnptgs5dZ0BiCnTaDLMbYRhM_hOXAQVnVbu6eEsiT1sWNmtPEgZ9zNV1gskUEvXrMO9wmyFGP0iCkXPxmuzDfiHi.Uprr1.NgSTtJLL67yh9D_MTUCsW_oMu3oaGzxSka8BYIW0wNxoBFAmDHS68iJ.sfkruMcZ6GAEixQJZo1C3QT2Y92AYqbFq0zMvYs6y9eSQAdHZdvU7M0giEFEl0EMxNCzM2IxmiX3pM0iaTRkikncM3CnEnTcWkTZAlH2otAkQkxmTP.FN8IuJLM6xPlgdaffRZv43PifCLiirNM8gP5MvPRDWUw6_bVavj_TNAMqEzEuUKOOLj_gBQ.HpV5LplD0bwup9QyaOHOOjAb.a9S4xYtoR5Une_9qhIJqvw.MqUPbMfvLUphbQUUESc9fNiHmv2To0Aig9KAe47iL2tVK7cnYFMyUZjbfcE5NmSNTpzTo8YAQUs8fKO1GyyZEu.3O__WUFBaOZ6PrvvhoHEwNBnjSSS4RUlHyGA.P5dPr42g_YAbMzTWgJDGDU50t1ns4pHLdAidKu2uoOkcs83I80qPoo7B81RgDDzfBbWJl5YJ6mD8ksIMoEeJF8sOfWIV7OIyykzvF.b7sX_su6.VkEnfm85ybbad3qXkEqOQC75EoDaPGSLpC.Dx2wZl55eK8q7aFlAczrHAbH9KuVByp7bmGGko5sSJgu_xk3J56dgU.rFYndBsIUwTxFYBCr5m6VQUzVq6K57ys56MpbRlh9DZHqTbJ0FN_HccAuu5Icquda03hw1rCYf5PB3.BFM7LFhMTV1jDDYZ_UmuOBvtRfTIOb9FQ45hJ.a_atZhgyEDlSHlalvaAmZv2tulSjPCB3eTK_MmLuA7fU7i1O2rQgLRH5_pocJpKplNxiKBAWvC3edezpguinBoJ1XOql9eYaALo87Hl4C3lJ0EaPRi81jsfuPnf3naqhdp8BsXYMbBcLa4tnU_NCD46fB5oNfECd134P_B0gvevv7yAj0_SG4ZaGEDWnImmL7m2WlLxhgrAxUxAkuXZe6rc8eQVNJMMkmOVX9UfnrK9n0XSL7K8A0BWu7uTkF68r9RH2fMHdRWexJwUdn611hbyWcSsVaeeaon1LAMCmJAbyBDP9hGh.XKty3NgZYkz6lY6I3Qf3bjurHmSWjjMTsxB0dSiBJ43t57g9UbLHOEvA_VMAW.2scFd.MZYfMfYDY.u19LVU5JL.DObkyiMoeCstKJFq7etnDHZP_5sgs35PWKLHKYMQqCdilmO4n5T.qxYno9epg3fsOPyckQ_xzsaFnm9QFTw4XxZQXOrZR90sSCpUmg_SFpHN.jDdrsxKapflVtqQbo_1fkMEGmL1f5zDHXvI1qfuQw0bArO4R2gqoqvBwyPap2ti_eFljfo.1oec2NaXhQPDkHELKJdM_e64pIfPGWnhCZ4YdkE6rIMBRMU26i9Kqc8UfiQZsoMdgiANpwbc.E120t6vT3fjV2xQxMHAXVIpBE7ay995gGwom9MC5C.ermBGC1LsHNGNXV1j014kuANUpghIfqMp81BustNciHOZRkoYQKZf7K3QwtVdqiMiv5THj0VPRRcGwE4dAiMJYP1Rs!
 m9vkW0bVIc0L06a10k7KdKLtlAFLhBDSrWaCk3zOd1Y4A2j9pmrLmedF0cElY3vMeQYtS.iBO_FJAZhq2Yp6L37pksnWWdFggOCBM6lhw5sQumQexSQ5eKHt8N4MLRdSHL0_54h739jeYHzExowigUQmH0azd83DcFwwyZ6q7Ci2et3HhqtwNrc10lypwOFtjnaLjhGHjzNYxQVb.W31BijmDPQLIy2huB8cgZquRm.t1hyImRy0IxxIFFlod_jN7dkcUP5z
X-Mailer: YahooMailClassic/8.1.6 YahooMailWebService/0.8.100.260964
Date: Mon, 7 Dec 2009 14:19:20 -0800 (PST)
From: Mercedes Benz Xmas Cash Splash <don-wilson@sbcglobal.net>
Reply-To: edward.howell@discuz.org
Subject: 950.000.00 GBP has been awarded to you in our Mercedes Benz Xmas Splash send your details
To: undisclosed recipients:;
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Name:.............. Address:..........
Country:........ Phone Number:.....
