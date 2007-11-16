Return-Path: <linux-kernel-owner+w=401wt.eu-S934204AbXKPAEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934204AbXKPAEB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 19:04:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764136AbXKPADw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 19:03:52 -0500
Received: from main.gmane.org ([80.91.229.2]:46324 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755129AbXKPADv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 19:03:51 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Wes Felter <wesley@felter.org>
Subject: Re: Treat disk space like memory space
Date: Thu, 15 Nov 2007 18:03:16 -0600
Message-ID: <fhimnu$5bm$1@ger.gmane.org>
References: <jwvr6irqhn2.fsf-monnier+gmane.linux.kernel@gnu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: bi01p1.co.us.ibm.com
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
In-Reply-To: <jwvr6irqhn2.fsf-monnier+gmane.linux.kernel@gnu.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Monnier wrote:

> So I'd like to be able to say "these areas of my file-system hold data
> that you can discard whenever you need space".  So I can freely fill up
> my disk with such irrelevant data, safe in the knowledge that if I ever
> need this disk space it'll be automatically reclaimed.

James Cipar, Mark D. Corner, Emery D. Berger: TFS: A Transparent File 
System for Contributory Storage.

"TFS provides background tasks with large amounts of unreliable 
storage-all of the currently available space-without impacting the 
performance of ordinary file access operations."

http://www.usenix.org/event/fast07/tech/cipar.html
http://prisms.cs.umass.edu/tcsm/

It's intended for P2P but I could imagine using it for caches.

