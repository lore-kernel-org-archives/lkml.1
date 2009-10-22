Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbZJVWxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbZJVWxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 18:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755136AbZJVWxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 18:53:51 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:22303 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbZJVWxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 18:53:50 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH v2 0/9] PCI, PNP: print resources consistently
Date: Thu, 22 Oct 2009 16:53:52 -0600
User-Agent: KMail/1.9.10
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Joe Perches <joe@perches.com>, Len Brown <lenb@kernel.org>
References: <20091013192040.22336.84876.stgit@bob.kio>
In-Reply-To: <20091013192040.22336.84876.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910221653.53072.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not planning another version of this series because I don't
think anybody's raised substantive issues.

The only thing I see as a potential issue is the increased stack usage:
in resource_string(), the buffer grows from 40 to 73 bytes (64-bit)
or 24 to 52 bytes (32-bit).  I could imagine using a stack buffer and
a mutex for this, but I'm not sure it's worth the code complexity yet.

Bjorn
