Return-Path: <linux-kernel-owner+w=401wt.eu-S932681AbZJAO2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681AbZJAO2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932672AbZJAO2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:28:16 -0400
Received: from fifo99.com ([67.223.236.141]:38966 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932670AbZJAO2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 10:28:13 -0400
Subject: Re: [PATCH 5/5] checkpatch: fix false EXPORT_SYMBOL warning
From: Daniel Walker <dwalker@fifo99.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20090930174644.GG2957@shadowen.org>
References: <1253585691-10987-1-git-send-email-dwalker@fifo99.com>
	 <1253585691-10987-2-git-send-email-dwalker@fifo99.com>
	 <1253585691-10987-3-git-send-email-dwalker@fifo99.com>
	 <1253585691-10987-4-git-send-email-dwalker@fifo99.com>
	 <1253585691-10987-5-git-send-email-dwalker@fifo99.com>
	 <20090930174644.GG2957@shadowen.org>
Content-Type: text/plain
Date: Thu, 01 Oct 2009 07:28:11 -0700
Message-Id: <1254407291.18167.98.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-30 at 18:46 +0100, Andy Whitcroft wrote:

> In theory the thing we are exporting can be an arbitrary number of lines
> prior to the EXPORT_SYMBOL statement.  We actually want to look at the
> statement before the EXPORT_*. 

Why not maintain a variable that holds the name of the function of
structure that is currently getting parsed .. So that you wouldn't need
to look back X lines to find anything ? Or did you do that in the
0.29-5-* version?

Daniel

