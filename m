Return-Path: <linux-kernel-owner+w=401wt.eu-S1764284AbXLUCdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764284AbXLUCdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 21:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbXLUCc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 21:32:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332AbXLUCc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 21:32:58 -0500
Date: Thu, 20 Dec 2007 21:30:31 -0500
From: Dave Jones <davej@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org
Subject: Re: [Jan Beulich] [PATCH] constify tables in kernel/sysctl_check.c
Message-ID: <20071221023031.GA23320@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org
References: <m1r6hh6jsy.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1r6hh6jsy.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 04:14:05PM -0700, Eric W. Biederman wrote:

 > Remains the question whether it is intended that many, perhaps even
 > large, tables are compiled in without ever having a chance to get used,
 > i.e. whether there shouldn't #ifdef CONFIG_xxx get added.

 > -static struct trans_ctl_table trans_net_ax25_param_table[] = {
 > +static const struct trans_ctl_table trans_net_ax25_table[] = {

we lost the _param, which will cause a duplicate definition with ..
 
 > -static struct trans_ctl_table trans_net_ax25_table[] = {
 > +static const struct trans_ctl_table trans_net_ax25_table[] = {

cut-n-paste thinko ?

	Dave

-- 
http://www.codemonkey.org.uk
