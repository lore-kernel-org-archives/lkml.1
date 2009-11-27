Return-Path: <linux-kernel-owner+w=401wt.eu-S1752596AbZK0MDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbZK0MDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 07:03:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbZK0MDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 07:03:15 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:50081 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbZK0MDO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 07:03:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:mime-version:content-type:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to:x-mailer;
        b=QgGB2m2XeXu72brjV+8lpKR+nqGu2XhyFlpgFYRcirTQfMeZ0Y+oBJNkeFPaek60T+
         jHOLOT1MWJxkgU9CSN2UApd1o7voChYAjb2gFBQ4wn9X2NsGl+f8B6JD7B5kZASAFe/W
         8KVUo/FDNllwypsOo5aKw9Debt4ZhZhlUFfew=
Subject: Why the kernel remove some LSM related functions?
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Wei Chen <acee06.weichen@gmail.com>
In-Reply-To: <C5B8AF15-0D1A-4A72-AFF6-684405331FCD@osss.cs.tsukuba.ac.jp>
Date: Fri, 27 Nov 2009 21:03:17 +0900
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <9C0E1031-67FD-4C14-A199-F4A878277438@gmail.com>
References: <C5B8AF15-0D1A-4A72-AFF6-684405331FCD@osss.cs.tsukuba.ac.jp>
To: chris@wirex.com, greg@kroah.com, ssmalley@nai.com
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent kernel of linux has removed the exported symbol of register_security() for Linux Security Module; so when I want to develop my own security module on 2.6.28, I have to modify the kernel to export the symbol and recompile the kernel source. 

Besides, the kernel has completely removed the functions of mod_reg_security() and mod_unreg_security(), which makes me unable to stack the security module. The only approach is to disable the active security module like SELinux and register mine.

Here, I want to know why the kernel did so. 

Thank you!

