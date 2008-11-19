Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbYKSSPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbYKSSPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 13:15:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbYKSSPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 13:15:36 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:25251 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbYKSSPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 13:15:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:content-type:content-transfer-encoding
         :mime-version:subject:date:cc:x-mailer;
        b=Xu7WF5vjI3uEqPg6xVoZrMT4gMFT1cp1g6QJqeLjddjGpuDeYaU0QvUL7GqWwmjmHC
         /EY1bUXTeIC4O7hlnH7mHbeXc54Mn2JQ8zIcq8Pi0Ex64Gv/63PzCq2Irl4J+ubyQ5uf
         AI6DgVQtWgwlsNvE5D1V/N6LSDsTIdIFOvasw=
Message-Id: <E749C9B9-2E83-4F54-A1C8-CBF376ECBD57@gmail.com>
From: Richard Holden <aciddeath@gmail.com>
To: linux-next@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: pci_read_config_* functions and uninitialized warnings?
Date: Wed, 19 Nov 2008 11:15:32 -0700
Cc: linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm building linux-next and seeing a lot of uninitialized warnings  
that go back to values being set using pci_read_config_* functions.  
Does anyone more familiar than I am with that code have any ideas on  
how to get GCC to realize that the pci_read_config_* initialize the  
vars. I don't want to end up submitting a lot of patches with  
uninitialized_var to fix the problems.

gcc --version: gcc (GCC) 4.1.2 (Gentoo 4.1.2 p1.1)


-Richard Holden
