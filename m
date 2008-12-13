Return-Path: <linux-kernel-owner+w=401wt.eu-S1751334AbYLMPsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbYLMPsU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 10:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbYLMPsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 10:48:09 -0500
Received: from rv-out-0506.google.com ([209.85.198.226]:11826 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbYLMPsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 10:48:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Hl//z53wzFDOGNZ0EjM3yvc5JmgUsIOkWAnsJB30+jHUzFmyWiZCtSnc0JrTH1zjqh
         gMe4On1OerpbypDJPIpOZrw87EK7Kr8ayo0n4fpT1FHADSLs581IkOE73sSKoYPD4yVb
         qt0dIJ7uwD7pE0OZe7SQS8osAAXz1D6+RNeAA=
Message-ID: <41d311580812130748o262fdb31se647e840977d90a9@mail.gmail.com>
Date: Sat, 13 Dec 2008 23:48:07 +0800
From: "pl ice" <telent997@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: when interrupt came, the kernel save pt_regs->eip always the same?
In-Reply-To: <41d311580812130740k6e0c139kacb5bad33b5b8fd4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <41d311580812130732u58f480ecgc21cb6f16365d45a@mail.gmail.com>
	 <41d311580812130740k6e0c139kacb5bad33b5b8fd4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI,
    These day i wanted get cpu context ,when interrupt came.BUT i
found when interrupt came kernel saved cpu context in struct pt_regs
and delivered to do_IRQ ,and i print the pt_regs->eip,they alway same
on the same interrupt?
     The interrupt can come anytime,i think the eip will be very
different every time.BUT i debug kernel ,print eip in the function
do_IRQ,found it didn't run as i thought.Can anybody tell me why?


sincerely yours
