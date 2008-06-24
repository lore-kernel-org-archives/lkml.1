Return-Path: <linux-kernel-owner+w=401wt.eu-S1757175AbYFXIQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175AbYFXIQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 04:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbYFXIQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 04:16:17 -0400
Received: from web36708.mail.mud.yahoo.com ([209.191.85.42]:46968 "HELO
	web36708.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752410AbYFXIQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 04:16:15 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jun 2008 04:16:15 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=QWwfMdFASsWjAgpoz7Pieb1cmH/vkAVFTWlUbxPYgvFXkUVSpUnuXaiXCY5/Hobu+IKa+aekWafU1S3kYLqLpOMueJ3TEdjWu+Xu8z4jA2DxH/sBcBI17FTpliz8iQFJURkeT+vt8hd9+mnmjfwUbq014+uG79Fh1tUXbC7j17U=;
X-Mailer: YahooMailWebService/0.7.199
Date: Tue, 24 Jun 2008 01:09:33 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Reply-To: oakad@yahoo.com
Subject: powerpc: using rapidio with MPC8548 board and 2.6.25 kernel
To: linux-kernel@vger.kernel.org
Cc: mporter@kernel.crashing.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <417427.64488.qm@web36708.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an MPC8548 board (MPQ101 by Mercury) and I want to put a recent version of linux on it. I'm also especially interested in the rapidio interface, which is currently (on my board) supported by some sort of custom driver.

However, it appears, that rapidio driver won't build on 2.6.25+ kernels because of changes in general kernel architecture. And Kconfig for this feature is incorrect too (this is easily fixable, of course).




      
