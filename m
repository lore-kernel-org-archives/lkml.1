Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbYLBL6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbYLBL6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 06:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbYLBL6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 06:58:44 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:60020 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbYLBL6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 06:58:43 -0500
Date: Tue, 2 Dec 2008 12:58:41 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org,
       xemul@openvz.org
Subject: Re: [RFC][PATCH 1/5] pid: Implement ns_of_pid
Message-ID: <20081202115841.GC1132@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, oleg@redhat.com,
	ebiederm@xmission.com, roland@redhat.com, containers@lists.osdl.org,
	linux-kernel@vger.kernel.org, xemul@openvz.org
References: <20081126034242.GA23120@us.ibm.com> <20081126034442.GA23238@us.ibm.com> <20081127011910.GD13545@wavehammer.waldi.eu.org> <20081201202422.GD12493@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20081201202422.GD12493@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2008 at 12:24:22PM -0800, Sukadev Bhattiprolu wrote:
> Bastian Blank [bastian@waldi.eu.org] wrote:
> | On Tue, Nov 25, 2008 at 07:44:42PM -0800, Sukadev Bhattiprolu wrote:
> | > +/* ns_of_pid returns the pid namespace in which the specified
> | > + * pid was allocated.
> | > + */
> | > +static inline struct pid_namespace *ns_of_pid(struct pid *pid)
> | > +{
> | > +	struct pid_namespace *ns = NULL;
> | > +	if (pid)
> | > +		ns = pid->numbers[pid->level].ns;
> | > +	return ns;
> | > +}
> | > +
> | When can the pid argument be null?
> Soon after creation but more importantly, after detach_pid()
> (release_task).

pid is a function argument and the function does not call detach_pid. So
please try again.

Bastian

-- 
Spock: The odds of surviving another attack are 13562190123 to 1, Captain.
