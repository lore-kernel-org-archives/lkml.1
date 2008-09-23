Return-Path: <linux-kernel-owner+w=401wt.eu-S1753235AbYIWSuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbYIWSuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 14:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbYIWSui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 14:50:38 -0400
Received: from web50905.mail.re2.yahoo.com ([206.190.38.125]:37441 "HELO
	web50905.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751395AbYIWSui convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 14:50:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.br;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=lugBUr1PtKBxv5Zf1IoBPvRJz9U8XHZSCmJG8IkvbgzqRAVUOk2ocyZuvvs0nTVKmGgjKM9nk6cS+D11EU81XViid4M0iS5FZw00EVCqbYzOLuqWLtnSf7uipDWYP8VmJ6E/oLFoFlATM/a1VOmusSFJV46tqJYwvk1qV7ZrOQw=;
X-YMail-OSG: EbdYR2gVM1lrnj1.ZDBlE99y2SgeiCtFlnl8LEu4D8O_k_N8FnNKk1n7b9bNiK2e0Qp2BmeIxD1kD_E8BjJrONWxxWKuPrhOoIqyWJUyXjl9eDiNqDJlOMSPrn9Qpwvrmfh7BnU3xPMs1Q9UwFUf3h_Ow5Ay9vY4Is0e0U0S5.rhbPFkIhc-
X-Mailer: YahooMailWebService/0.7.218.2
Date: Tue, 23 Sep 2008 11:50:37 -0700 (PDT)
From: Joilnen Leite <knl_joi@yahoo.com.br>
Reply-To: knl_joi@yahoo.com.br
Subject: about kernel_physical_mapping_init
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080923184315.13f0923f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <323704.34129.qm@web50905.mail.re2.yahoo.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wondering if inside kernel_physical_mapping_init, putting the line:
  pmd = one_md_table_init(pgd);
after the:
  if (pfn >= max_low_pfn)
    continue;
could to improve something one time it dont go to one_md_table_init(pgd) in true case for if statment


Joilnen


      Novos endereços, o Yahoo! que você conhece. Crie um email novo com a sua cara @ymail.com ou @rocketmail.com.
http://br.new.mail.yahoo.com/addresses
