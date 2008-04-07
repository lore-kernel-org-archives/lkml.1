Return-Path: <linux-kernel-owner+w=401wt.eu-S1758365AbYDGMMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758365AbYDGMMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 08:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755679AbYDGMMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 08:12:39 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:52242 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086AbYDGMMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 08:12:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=KGaiJC9FRk2tJj+3wf7D3dvUg2eCgJ5abqeNn3HZ/zllNc2wSOOkCW9nfKHmaEzk8LnvtT6OlHqKYP2v1F9L/cR7L6OToRgd58cczUxUnAmXyaAA7/hMcKWmibcXBkM7o+Gd9aYlUj1TBClco93rBbPHFRHZPzY5YpdCeCgtBRg=
Message-ID: <2f11576a0804070512g4421d4aar84fe659c21dda8a9@mail.gmail.com>
Date: Mon, 7 Apr 2008 21:12:37 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [-mm] Disable the memory controller by default
Cc: andi@firstfloor.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>,
       "Paul Menage" <menage@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, "Pavel Emelianov" <xemul@openvz.org>,
       hugh@veritas.com, "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080407115137.24124.59692.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080407115137.24124.59692.sendpatchset@localhost.localdomain>
X-Google-Sender-Auth: ddb37bf2bae9171e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

>  diff -puN Documentation/kernel-parameters.txt~memory-controller-default-option-off Documentation/kernel-parameters.txt
>  --- linux-2.6.25-rc8/Documentation/kernel-parameters.txt~memory-controller-default-option-off   2008-04-07 16:38:25.000000000 +0530
>  +++ linux-2.6.25-rc8-balbir/Documentation/kernel-parameters.txt 2008-04-07 17:20:08.000000000 +0530
>  @@ -381,9 +381,10 @@ and is between 256 and 4096 characters.
>         ccw_timeout_log [S390]
>                         See Documentation/s390/CommonIO for details.
>
>  -       cgroup_disable= [KNL] Disable a particular controller
>  -                       Format: {name of the controller(s) to disable}
>  +       cgroup_toggle= [KNL] Toggle (enable/disable) a particular controller
>  +                       Format: {name of the controller(s) to enable/disable}
>                                 {Currently supported controllers - "memory"}
>  +                               {The memory controller is disabled by default}
>
>         checkreqprot    [SELINUX] Set initial checkreqprot flag value.
>                         Format: { "0" | "1" }

Hmm..

toggle parameter seems no good idea.
because if change default value in the future, boot parmeter becomes
an opposite meaning.

thus, we can't change default value even if we will be able to get
enough performance improvement in the future.

Thanks
