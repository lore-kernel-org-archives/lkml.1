Return-Path: <linux-kernel-owner+w=401wt.eu-S1161039AbXBZU67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161039AbXBZU67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 15:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161038AbXBZU67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 15:58:59 -0500
Received: from web26902.mail.ukl.yahoo.com ([217.146.176.91]:46693 "HELO
	web26902.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161039AbXBZU66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 15:58:58 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=Message-ID:X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=dNEi8NGC1vB3efr8Wq3GtNjHK5CNnPaaZxEzKGU/zmsG1Wx1hL5fAhaLank9L3MHAQ34mTy3TuzpefJiZbEBenl75Eu52/Fl0F5pPnv/+dvXNSls1gbXkxSEDYoDWXHOr6eqLlKbiW15ZALs+jfmhgv4Qn3wI1GXvH9o473aV1Q=  ;
Message-ID: <20070226205857.81286.qmail@web26902.mail.ukl.yahoo.com>
X-YMail-OSG: 380nyr0VM1kOe4U0vzy0D5_K5Gk7I25zNpHQ7_.RgaI8NJyDL_sFRoB3Wy62tqpzpoyMhpH5zhaZf.XriUtkGrZ2O8.5DX1BpOawgbmXMyWOuUnEDCavb_MoAbw3YFgSRTThBiZBrVQ-
Date: Mon, 26 Feb 2007 21:58:57 +0100 (CET)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: Re: bug in kernel 2.6.21-rc1-git1: conventional floppy drive cannot be mounted without hanging up th
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 For me, adding the "local_irq_enable();" in default_idle() of arch/i386/kernel/process.c
make the floppy work again without problem.

  Etienne.


	

	
		
___________________________________________________________________________ 
Découvrez une nouvelle façon d'obtenir des réponses à toutes vos questions ! 
Profitez des connaissances, des opinions et des expériences des internautes sur Yahoo! Questions/Réponses 
http://fr.answers.yahoo.com
