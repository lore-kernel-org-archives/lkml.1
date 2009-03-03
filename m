Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbZCDAch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbZCDAch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 19:32:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbZCDAc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 19:32:28 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:52971 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbZCDAc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 19:32:27 -0500
Subject: Re: [PATCH 1/3] s390: Expose a constant for the number of words
	representing the CRs
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Dan Smith <danms@us.ibm.com>
Cc: containers@lists.osdl.org, linux-s390@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1236095764-19325-2-git-send-email-danms@us.ibm.com>
References: <1236095764-19325-1-git-send-email-danms@us.ibm.com>
	 <1236095764-19325-2-git-send-email-danms@us.ibm.com>
Content-Type: text/plain
Date: Tue, 03 Mar 2009 08:08:14 -0800
Message-Id: <1236096494.22399.5.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-03 at 10:56 -0500, Dan Smith wrote:
> We need to use this value in the checkpoint/restart code and would like to
> have a constant instead of a magic '3'.

This doesn't do a lot of good unless it gets used in the base s390 code.
Otherwise, why not just define it near its use in the c/r code?

-- Dave

