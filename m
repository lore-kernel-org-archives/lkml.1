Return-Path: <linux-kernel-owner+w=401wt.eu-S933947AbYDQRuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933947AbYDQRuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 13:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759518AbYDQRu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 13:50:26 -0400
Received: from smtp-out.google.com ([216.239.33.17]:55959 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758754AbYDQRu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 13:50:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Yis8Av5FvwFJhGAYl+Vq4ujI4xjP+oxu7rMpDm/M3ZpmlsaYPW/vxPFadUx1qdL25
	w4Ro70lcM74B4lOKNgLbQ==
Message-ID: <6599ad830804171050u412b5a56o8e93b21008ad17c4@mail.gmail.com>
Date: Thu, 17 Apr 2008 10:50:13 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [Fwd: [-mm] Add an owner to the mm_struct (v9)]
Cc: "Oleg Nesterov" <oleg@tv-sign.ru>,
       "Andrew Morton" <akpm@linux-foundation.org>, serue@us.ibm.com,
       penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org
In-Reply-To: <48078B9B.9070508@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48036677.3010807@linux.vnet.ibm.com>
	 <20080414170709.736819b6.akpm@linux-foundation.org>
	 <20080415171359.GA352@tv-sign.ru>
	 <6599ad830804151113i73010bb4x48e658195f295d41@mail.gmail.com>
	 <20080415195950.GA113@tv-sign.ru>
	 <4806C633.3000302@linux.vnet.ibm.com>
	 <20080417113000.GB103@tv-sign.ru>
	 <6599ad830804170934i6df9fe42kd979492babe03be@mail.gmail.com>
	 <20080417161936.GB4482@tv-sign.ru>
	 <48078B9B.9070508@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 10:40 AM, Balbir Singh
<balbir@linux.vnet.ibm.com> wrote:
>  >
>  > Please look at copy_process, CLONE_THREAD requires CLONE_SIGHAND,
>  > CLONE_SIGHAND needs CLONE_VM.
>  >
>
>  What about the other way round, CLONE_VM without CLONE_THREAD?
>

That's just a standard LinuxThreads clone() call. The patch handles
that just fine.

Paul
