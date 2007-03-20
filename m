Return-Path: <linux-kernel-owner+w=401wt.eu-S933930AbXCTPkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933930AbXCTPkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 11:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933961AbXCTPkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 11:40:43 -0400
Received: from mailout17.yourhostingaccount.com ([65.254.253.136]:40422 "EHLO
	mailout17.yourhostingaccount.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933930AbXCTPkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 11:40:42 -0400
Message-ID: <002701c76b06$1a591510$0864a8c0@scs1>
From: "Tasos Parisinos" <t.parisinos@sciensis.com>
To: "James Morris" <jmorris@namei.org>
Cc: "Francois Romieu" <romieu@fr.zoreil.com>, <herbert@gondor.apana.org.au>,
       <linux-kernel@vger.kernel.org>
References: <45FEB8B7.7020200@sciensis.com> <20070320004001.GA11601@electric-eye.fr.zoreil.com> <000601c76af9$a0ce3ce0$0864a8c0@scs1> <Line.LNX.4.64.0703201109210.3028@d.namei>
Subject: Re: [PATCH RESEND 1/1] crypto API: RSA algorithm patch (kernel version 2.6.20.1)
Date: Tue, 20 Mar 2007 17:40:17 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3028
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-EN-UserInfo: 6b5ac0c6b5a8f649d336ffa6ba3f3bc4:297516c839f78035fb456ced5af6b435
X-EN-AuthUser: tparisinos@sciensis.com
X-EN-OrigIP: 88.218.52.108
X-EN-OrigHost: dsl-88-218-52-108.customers.vivodi.gr
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, from what i read, there are many-many similarities in objective but i think
that i take a different aproach in the solution

This is a mod for modular exponentiation only, and this is specific and simple,
cut-down and (as much as possible) overhead free. I don't use gpg structs and /or 
other code, don't depend anyhow on userland, don't care about elf formats, 
or where the signature is, or key management, i leave those up to the others 
to design 

this is just modular exponentiation as simple as can be

Tasos Parisinos
-
