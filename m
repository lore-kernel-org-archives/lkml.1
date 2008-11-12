Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbYKLWOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbYKLWOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 17:14:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbYKLWOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 17:14:25 -0500
Received: from web32401.mail.mud.yahoo.com ([68.142.207.194]:29169 "HELO
	web32401.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751331AbYKLWOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 17:14:25 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=lXBpU94bC4Xi0tWArs11D6r9WXHrQ9LkSwJd5iI9bUb3VO7V3PRFnNgU8saW/ePl/V+v77d/tJQUUegtZtoHhxtUCBX/hlAKHYFTn4eeKek7G8vq9z4vqhvbkSa8I0glcS6IKrQm6atW/Rfe27Ga+PNFYZI6fYFl5j6kk4kjqgs=;
X-YMail-OSG: eS72aqYVM1lZn38aUmka0actK8Wla4suf60LAnag1T2YHsaAGn4Hal8DDbj71s0Br.d4j4AspXCy.Y9vDfRwQ6U_O_F7gs0M2o49ru_w3zPAJv3d_EjBonKj8ulQdZ1wgis3MGLA.71Y_lBD7rcoos3q_i8TSyjebz3QA4I-
X-Mailer: YahooMailWebService/0.7.260.1
Date: Wed, 12 Nov 2008 14:14:24 -0800 (PST)
From: Anil kumar <anils_r@yahoo.com>
Reply-To: anils_r@yahoo.com
Subject: dma_pool_alloc restrict < 4GB address
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <231988.14599.qm@web32401.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is there anyway to restrict the returned bus address(dma address) from dma_poll_alloc to < 4GB ?
The function returns a dma address(of type dma_addr_t). Is there anyway I can ensure to restrict it to < 4B address.
I guess we can do that in pci_alloc_consistent as by default it returns 32bit address. 

with regards,
  Anil


      
