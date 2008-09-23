Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbYIWRtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbYIWRtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 13:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbYIWRtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 13:49:01 -0400
Received: from web50901.mail.re2.yahoo.com ([206.190.38.121]:20563 "HELO
	web50901.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751822AbYIWRtB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 13:49:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.br;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=r7yq3D581YqEIgBBdErWXX4S5XiKEprsTP8Xx4dn5e5dwPQRph0YAwH18hsTB5CihIsFqbuvHaf6Z0wF4peIYMFcnsK+U5ZfYbj7WcgQ7Ag6ZkfMhntN8YdUYFWzBFIGqYeZcQmbJg/TvKXmMgQKDXXUNGnEbvnPiIm8RjdfFgA=;
X-YMail-OSG: Xw209CwVM1nnV_tifrWk7U2M0wbYj3MaiUp06mUDEATFpkgVO28kOM4dCY9G.uU1tp_cBLRI8WnWosknWUwb9arkPPZYYtQarClzu8hShc44OxIAFPdjVYdOi_GvAhpTTuZC2faJEkqh0pAHYMFZOR.MOrNh4laFs8DThsFbY3b0Qoe9jUg-
X-Mailer: YahooMailWebService/0.7.218.2
Date: Tue, 23 Sep 2008 10:48:59 -0700 (PDT)
From: Joilnen Leite <knl_joi@yahoo.com.br>
Reply-To: knl_joi@yahoo.com.br
Subject: about kernel_physical_mapping_init
To: linux-kernel@vger.kernel.org
In-Reply-To: <20080923184315.13f0923f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <271133.81014.qm@web50901.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wondering if putting the line
  pmd = one_md_table_init(pgd);
after the
  if (pfn >= max_low_pfn)
    continue;
could be a improve one time it not need to go to one_md_table_init, in case true for if statment.


Joilnen


      Novos endereços, o Yahoo! que você conhece. Crie um email novo com a sua cara @ymail.com ou @rocketmail.com.
http://br.new.mail.yahoo.com/addresses
