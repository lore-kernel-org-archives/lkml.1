Return-Path: <linux-kernel-owner+w=401wt.eu-S965051AbZLGVZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965051AbZLGVZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 16:25:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965036AbZLGVZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 16:25:05 -0500
Received: from web81602.mail.mud.yahoo.com ([68.142.199.154]:43313 "HELO
	web81602.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S935598AbZLGVZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 16:25:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=ikTZ94vHt9vwOdga+O6wSNaL5NCC43Z2PMrE7gBgX7fs1N2CGU3VO7D4744FQGmW5EWwZJcNJI9s238mTz8zutMOczIfT2AqDiLXuQI//qYQ7/d0LKRjb7OjlrfLG10Oo++zc3IkAZwCf37In1u10GVV9scKzRdDq9tb0ZyV9KM=;
Message-ID: <654517.12733.qm@web81602.mail.mud.yahoo.com>
X-YMail-OSG: a6srBhQVM1k9mqmRVzZKULlEwyCsAziPv1747qOr4ClAW6BpAy6USLslI.WLk3Ai3HmXILAuWtbtjsgTgQnKhM9mlSskrTvm8fiuU51TiQzWpK3vqQSOMuzWo5cyYdoNdNlXIdj6Sc0HteGP0LIbVrxUV_YRO.HN7iHfIB90yT8bDqryszdSW4A4jmTHnLL7x1VHzBwzBdkM44leJTVV22HBypyzD_N6tUqVjYjNDofi4fy_T_rlljsV2XOvrJLFNeaefceDlsugNu0iviQ_IhPGiurBExhUjctvyw17f5QOGOhP1e5GvB0dmvF.6A_T.Mab94vanInjCZV9EU5oqrm7g6XJa.qQLKf25pLuJQiAJcRgTTS5orQnuvNMJ3Hd1B8UCgCCy9l8EhisaMEKxmV3G1QjPAqEZSmRKy.gntGBSY52aASIiRoZ76A4KIoGR3WI_zAmo7W8KD4evdIBNLzOd5qU43mddwnPA_kEv9PrlJ9jEGns66FVvUk_kiSX_U0W.OTD4wCNjuokG0HVVyVf_vXnTD1qTV3B2AQIT7pdp7Yko3up2JMVIctCpcGDpZVSCUEBCXHSWK0HyyupT4Lz43vIYFyOh7gHpgeIK.h_i_0h_mjtdPm.nGp2PIpJbtlQwOvlOj4yy.D0pD8f82BQgwTAg8GzE6C_GxAhQrghwa88APYLO_n2UNVTcMGH3AQaVKhF.2ZhmVJ1oshnX6tJsqUCovVWG.Cx4ehdNGR7.2F.C2t4YJQM4pI_eNRyshV0inpfSud7i.BEgss.82YgvJ3jruL8FeVYnXy1vTyG57N591vwGo7vkkaM8E4TtjhLhQSKMqNc6CevfCCJvX4p5ZGRvhYMgN5TYeIu_kLLKjcmi.sOd4AsS.q29S9EOgl.8MTNXeYgv9edfnKGiVdtQSqd75PAR0ODgrieMIjHQBHi4Io0aZ3ybsSYWLI_vZNsv8G1yfnXNGPSV_eDbsCXV01G1Uc0ZOuRKsQcJVYPRRshDbCuIgB0wJvpFmF1PAhwk8wCFpB828MsiRLUpsRJo.X3KwU3RQ3NKwHpQoJd2ByJEJ9jwEQtac3Juz.tHCE.CzteOhhVgvYTR8gw7IAKWrOEqC4rge6O9Uc5yOmOxf2JQIQyJcFk94zcLwwsFhBFtzA5ju4eZek5ZyXNx1QJ1L138XOZod6eCvZvgK10jt_e.MPmE2tqp4e.mIpcjQOs45SvcMTIHv4I.lBku2XCaCnUPRwElILTLSm1DzEd8CEp3Yse625RFzUCzMrluCPrHIYFqcss_FsZOupE9C6pTTqj8eLVXKReb28ZknTw5GlG5xlNPJ6RfooB.Jq3OYjBMzx0e4gFz4ndb2coTylIKnzbJSb.Rt0mSb5KxN2_BMz9KUd91sOQhM1HuKQgmUOR.HMUGnwJGQkNiJ2yGZMvEqCgUnh0zs.BHSZWUNykJP.aMDzlURzC8nQ6Ofgqn1l4tKWzOm02_5hUq2LzAs4s.uCg7_XseD714fLjTIJCffYGuiyWKiHmFDiGJY_nNas1fyTgV_VWLL4udE6p7KPBTmviL8ETmn6z7oiYSdz9bqIuuxrYdLV0QtqTsocV7PRJ0WXLI98noVyCNwi3Xvm5YKOmD4NcfqlyGRqPCjSy1ZQbBtTEPO9Ff_ntOnHuGoWqwU2QSGgW1DAMItRA9AexoayDb4.L0KkrF3ZOgAXpjTHYIaofgtMmzw.ubIQ17imdV4uLOoHVEqhXSS0fEN5Wg0IeKE6SiwDDRlapzOOBhJ1hPKGDSjOhoR7ZcScQe3omy32Y5qjJ3dMMAc_7LHhzzg.zJ.9_A06LTmXz9Y4.y7rkgHFeVF9KZwMlXjS.hZlWy10LyEd13yPqUb7adw_U9yHTv6yVk5Hvg1aSTQTGWwQCp30rJkZFdAayG4JLSEpPscAdZN6NaAtxKHeLAw4J17Hn6dZd1BbBtVChKRXMJyvMbLT_cRmuoh5w.ZzFAc3mtWWmXK7reBvJlzbKPYqPOGbMKxRzZQYzw8QxRE!
 oIFNxb34sdHLIZx6.3Q8o3MYYeyQUl0iYn5EQ60Iwe_anAh_xF4kguZoKd_zs3v4fCMqGC7EMP6SpDXT1W1sLta7AnNGjmclTayWoQ1dp3GKxmJa_9r6MJ1uiTMf1ZGYTUmqFa8ZIxDJ3X_H7RjDcoLNzqIrk57FjJOXGAmH3VCjbOmSwExK6XglCx1d5dF4AOnUlevRU8pMY.ihQ0LvW3cMV5fqY.QV_2IXpnfikOsUVkzsHa9vFm7AN6IZnxV8hPsHbaJd
X-Mailer: YahooMailClassic/8.1.6 YahooMailWebService/0.8.100.260964
Date: Mon, 7 Dec 2009 13:25:08 -0800 (PST)
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
