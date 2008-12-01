Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbYLAUZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbYLAUZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 15:25:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbYLAUYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 15:24:52 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50897 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529AbYLAUYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 15:24:51 -0500
Date: Mon, 1 Dec 2008 12:24:22 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Bastian Blank <bastian@waldi.eu.org>, oleg@redhat.com,
       ebiederm@xmission.com, roland@redhat.com, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, xemul@openvz.org
Subject: Re: [RFC][PATCH 1/5] pid: Implement ns_of_pid
Message-ID: <20081201202422.GD12493@us.ibm.com>
References: <20081126034242.GA23120@us.ibm.com> <20081126034442.GA23238@us.ibm.com> <20081127011910.GD13545@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081127011910.GD13545@wavehammer.waldi.eu.org>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bastian Blank [bastian@waldi.eu.org] wrote:
| On Tue, Nov 25, 2008 at 07:44:42PM -0800, Sukadev Bhattiprolu wrote:
| > +/* ns_of_pid returns the pid namespace in which the specified
| > + * pid was allocated.
| > + */
| > +static inline struct pid_namespace *ns_of_pid(struct pid *pid)
| > +{
| > +	struct pid_namespace *ns = NULL;
| > +	if (pid)
| > +		ns = pid->numbers[pid->level].ns;
| > +	return ns;
| > +}
| > +
| 
| When can the pid argument be null?

Soon after creation but more importantly, after detach_pid()
(release_task).

| 
| Bastian
| 
| -- 
| Another Armenia, Belgium ... the weak innocents who always seem to be
| located on a natural invasion route.
| 		-- Kirk, "Errand of Mercy", stardate 3198.4
