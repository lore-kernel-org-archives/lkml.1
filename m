Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbXLIWGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbXLIWGb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 17:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbXLIWGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 17:06:23 -0500
Received: from web52902.mail.re2.yahoo.com ([206.190.49.12]:33545 "HELO
	web52902.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751543AbXLIWGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 17:06:22 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=WiFpuirQ94pSP5ViHjOjsN8BQSkT7m61IFm9SuLEBpAMQV6P3jDC19mg69ArQt33HDaX4v3BMX67TcFrTWjILnx2QspKwdW0R7XhHBCbgCwl/Xl6kKpBdngqpen/HsnFiVUdYGX6C7vZKLApKNDMloZv576Q8EIObOhBbk5ggVk=;
X-YMail-OSG: g4o7zPAVM1kfiE2vWn4S3GDLbCghRZeqE9FdFshXVFdeq_xaDpHvL4lpSXc2b1dJjeRtihORJ_W7YfOJWAgzZHEjCxeqfsUMRF8rKxngEVlIZvehA.LyJhQLDYv49w--
Date: Sun, 9 Dec 2007 22:06:21 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [2.6.23.9] hostap_plx locks up PC when reading PCI I/O memory
To: Arjan van de Ven <arjan@infradead.org>
Cc: Dan Williams <dcbw@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <20071209133311.2db5ce4f@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <642708.11296.qm@web52902.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Arjan van de Ven <arjan@infradead.org> wrote:
> can you check if the attr_mem is properly ioremap'd ?
> (probably with ioremap_nocache)

Can you elaborate, please? I am not familiar with these I/O primitives.

> I wonder if there's anything else in that area as well..

So I should check /proc/iomem? But wouldn't Linux complain if two PCI devices conflicted as you're
suggesting?

Cheers,
Chris





      ___________________________________________________________
Support the World Aids Awareness campaign this month with Yahoo! For Good http://uk.promotions.yahoo.com/forgood/
