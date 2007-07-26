Return-Path: <linux-kernel-owner+w=401wt.eu-S1760703AbXGZDQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760703AbXGZDQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 23:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756462AbXGZDQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 23:16:31 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:26527 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772AbXGZDQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 23:16:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=K8dgs9yozOk633nsHeWzO2dW/acggWBapDWVxNbSr1wIhCLf9nG+c6TdMIi/jOBqm3zy201S7v11ygFhX6PTlhVgMTjz2TdkR1rt9nFZaNPzWcZhD8wJtzoxG11FA4FerRFjpYCVopDzEibMVk5UI+4I14QmJYcyx+aXCjzLbNU=
Message-ID: <b21f8390707252016o7f24ca8eg99e6895c7ab5cc53@mail.gmail.com>
Date: Thu, 26 Jul 2007 13:16:29 +1000
From: "Matthew Hawkins" <darthmdh@gmail.com>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: [ck] Re: -mm merge plans for 2.6.23
Cc: linux-kernel@vger.kernel.org, "ck list" <ck@vds.kolivas.org>,
       linux-mm@kvack.org
In-Reply-To: <2c0942db0707251832i542249d5ve0006b3db0374678@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <46A58B49.3050508@yahoo.com.au>
	 <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com>
	 <46A6CC56.6040307@yahoo.com.au> <46A6D7D2.4050708@gmail.com>
	 <Pine.LNX.4.64.0707242211210.2229@asgard.lang.hm>
	 <46A6DFFD.9030202@gmail.com>
	 <2c0942db0707250902v58e23d52v434bde82ba28f119@mail.gmail.com>
	 <b21f8390707251815o767590acrf6a6c4d7290a26a8@mail.gmail.com>
	 <2c0942db0707251832i542249d5ve0006b3db0374678@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/26/07, Ray Lee <ray-lk@madrabbit.org> wrote:
> Yeah, I know about inotify, but it doesn't scale.

Yeah, the nonrecursive behaviour is a bugger.  Also I found it helped
to queue operations in userspace and execute periodically rather than
trying to execute on every single notification.  Worked well for
indexing, for virus scanning though you'd want to do some risk
analysis.

It'd be nice to have a filesystem that handled that sort of thing
internally *cough*winfs*cough*.  That was my hope for reiserfs a very
long time ago with its pluggable fs modules feature.

-- 
Matt
