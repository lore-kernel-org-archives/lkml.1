Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbZD3KcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbZD3KcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 06:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbZD3KcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 06:32:09 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:40004 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbZD3KcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 06:32:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=YqPandmF+GGMshEVsX8NaJCnOGwLfQea27YPRC3fWH55lXExv2eooRVsBd2MktIyOC
         JKPtio6L/7BQ7p41SspbfcHfA4LXzP8dofQyas8/exk2RoPeUeQE+DqEMheahr6NbM96
         oveeO2gyImvKHRLxYvyvxGg1PnkpO6GX1jxww=
From: Eric Lacombe <goretux@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [unused symbol] need to use init_mm
Date: Thu, 30 Apr 2009 12:32:04 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; x86_64; ; )
Cc: Mel Gorman <mel@csn.ul.ie>, Eric Lacombe <goretux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904301232.05302.goretux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Within a module I work on, I need to access to init_mm, but as it is marked 
UNUSED, I wonder if there is another way (an API) to access to it.
Otherwise, what can I do to have this mark removed from init_mm in the 
mainline? as my module is really not yet ready for inclusion.

Thanks in advance for your response,

	Eric

