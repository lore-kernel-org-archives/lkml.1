Return-Path: <linux-kernel-owner+w=401wt.eu-S1754999AbZGBC4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbZGBC4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 22:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbZGBC42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 22:56:28 -0400
Received: from smtp-out.google.com ([216.239.45.13]:25029 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbZGBC41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 22:56:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=BVcQdqGCn3OSmZm+N6Qm/HsNIkjkUeBSDIihZ/SpgrOtzxxkMNh1dnG/byVDJ4Cdv
	jfVoSsTIcJtWXSlHjobmg==
MIME-Version: 1.0
In-Reply-To: <20090702114829.df04c885.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090702020624.14469.47066.stgit@menage.mtv.corp.google.com>
	 <20090702021133.14469.35140.stgit@menage.mtv.corp.google.com>
	 <20090702114829.df04c885.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 1 Jul 2009 19:56:28 -0700
Message-ID: <6599ad830907011956i33769d5ek5401e93553d75c59@mail.gmail.com>
Subject: Re: [PATCH 8/9] [RFC] Example multi-bindable subsystem: a per-cgroup 
	notes field
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 1, 2009 at 7:48 PM, KAMEZAWA
Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> Hmm, do we need to this "info" file as subsys ? How about making this as
> default file set ? (if there are users.)
>

That would certainly be possible, and would be an alternative to
having multi-bindable subsystem support.

The advantage of adding multi-bindable subsystems is that you can
avoid bloating the core cgroups code, by putting individual small
cgroups features in their own code modules, and you get to decide at
mount time which features are actually mounted; if they were part of
the core cgroups files, then there would either need to be special
mount options for each separate feature, or else no way to pick which
features were mounted on each hierarchy.

Paul
