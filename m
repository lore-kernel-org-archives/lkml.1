Return-Path: <linux-kernel-owner+w=401wt.eu-S1762155AbZATRhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762155AbZATRhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 12:37:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754995AbZATRhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 12:37:00 -0500
Received: from an-out-0708.google.com ([209.85.132.240]:6654 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbZATRg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 12:36:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=r5LsW101p4oh+gn+H7reTdUZI8BYWRcwr0mm5fjPFF7ErKcqoihW69p0yx1JatK/iC
         IVQzzV6HMSQCtFsQFxcBHzXeGjlvHeBAhLMrsExE8S3jz1aSR6qNqTj35XOT/7XlY8DT
         qHtCc/iFSKWpfuLeY158N8Z1abTqFZQLYGxD8=
Date: Tue, 20 Jan 2009 11:36:36 -0600
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org
Subject: Modversions and long symbol names
Message-ID: <20090120173636.GB24529@mediacenter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently when modversions is enabled the kernel will not load any
modules that depend on exported symbols with names longer than
64 - sizeof(unsigned long) characters.

This is because the struct modversion_info has the name member set to a
size of MODULE_NAME_LEN.  This is not the module name this is the symbol
name so I'm guessing this is a mistake or at least a misused constant.

Is it possible to increase this size to something more reasonable like
512 characters?

--
Shawn
