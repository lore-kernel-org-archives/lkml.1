Return-Path: <linux-kernel-owner+w=401wt.eu-S933216AbYB0BKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933216AbYB0BKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 20:10:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932810AbYB0BJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 20:09:59 -0500
Received: from smtp-out.google.com ([216.239.45.13]:27859 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbYB0BJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 20:09:58 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=EyPr0bG+Z9O4QESq8ICJaHCMvEL2kN91ooESiQbdqYO4Q5S45hpTm6TMayLW3smtZ
	3kkWVkWMtomnWujAGa7GA==
Message-ID: <6599ad830802261709s4f836d78uc856cb163a56615c@mail.gmail.com>
Date: Tue, 26 Feb 2008 17:09:48 -0800
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 05/10] CGroup API files: Update cpusets to use cgroup structured file API
Cc: akpm@linux-foundation.org, balbir@in.ibm.com, pj@sgi.com,
       "Pavel Emelianov" <xemul@openvz.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
In-Reply-To: <47C4B4B0.4010700@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080223224725.115590000@menage.corp.google.com>
	 <20080223232617.958345000@menage.corp.google.com>
	 <47C4B4B0.4010700@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 4:54 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> menage@google.com wrote:
>  > +     case FILE_MEMORY_MIGRATE:
>  > +             return is_memory_migrate(cs);
>  > +     case FILE_MEMORY_PRESSURE_ENABLED:
>  > +             return cpuset_memory_pressure_enabled;
>  > +     case FILE_MEMORY_PRESSURE:
>  > +             return fmeter_getrate(&cs->fmeter);
>  > +             break;
>
>  redundant 'break'
>

Thanks, I'll zap that.

Paul
