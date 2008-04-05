Return-Path: <linux-kernel-owner+w=401wt.eu-S1751766AbYDEDTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766AbYDEDTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 23:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbYDEDSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 23:18:50 -0400
Received: from qb-out-0506.google.com ([72.14.204.232]:64527 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbYDEDSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 23:18:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:message-id:to:cc:subject:from:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=JXjaa5/unlxBM2dNpo340GRBdAvRH1UeTGjZrpDIanMAnEG3mf1PwrQNV8xFq7NcqySjmJv+yGggYz2X4OngKP589i/7O8JAXgV5qY8zeS80MARI47e1viCKjcx4NKGzggsgv4/qFUmwXd/vTTySY9fjNDY/7FC251qdkqo3HK0=
Date: Sat, 05 Apr 2008 11:15:46 +0800 (CST)
Message-Id: <20080405.111546.71557462.xiyou.wangcong@gmail.com>
To: jdike@addtoit.com
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [Patch] arch/um/os-Linux/main.c: Fix memory leaks.
From: WANG Cong <xiyou.wangcong@gmail.com>
In-Reply-To: <20080404154901.GB11545@c2.user-mode-linux.org>
References: <20080401.230641.146239754.xiyou.wangcong@gmail.com>
	<20080404154901.GB11545@c2.user-mode-linux.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Dike <jdike@addtoit.com>
Date: Fri, 4 Apr 2008 11:49:01 -0400

> On Tue, Apr 01, 2008 at 11:06:41PM +0800, WANG Cong wrote:
> > 
> > This patch fixes possible memory leaks in the main() function of
> > arch/um/os-Linux/main.c.
> 
> I'm somewhat dubious about this - the memory is freed immediately
> before exiting, making this patch have no practical effect.
> 

I think all memory leaks indicate our logic is not right, although
this one maybe harmless.
