Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbYK0BPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbYK0BPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 20:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbYK0BPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 20:15:34 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:59041 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbYK0BPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 20:15:34 -0500
Date: Thu, 27 Nov 2008 02:19:10 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org,
       xemul@openvz.org
Subject: Re: [RFC][PATCH 1/5] pid: Implement ns_of_pid
Message-ID: <20081127011910.GD13545@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, oleg@redhat.com,
	ebiederm@xmission.com, roland@redhat.com, containers@lists.osdl.org,
	linux-kernel@vger.kernel.org, xemul@openvz.org
References: <20081126034242.GA23120@us.ibm.com> <20081126034442.GA23238@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20081126034442.GA23238@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 07:44:42PM -0800, Sukadev Bhattiprolu wrote:
> +/* ns_of_pid returns the pid namespace in which the specified
> + * pid was allocated.
> + */
> +static inline struct pid_namespace *ns_of_pid(struct pid *pid)
> +{
> +	struct pid_namespace *ns = NULL;
> +	if (pid)
> +		ns = pid->numbers[pid->level].ns;
> +	return ns;
> +}
> +

When can the pid argument be null?

Bastian

-- 
Another Armenia, Belgium ... the weak innocents who always seem to be
located on a natural invasion route.
		-- Kirk, "Errand of Mercy", stardate 3198.4
