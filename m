Return-Path: <linux-kernel-owner+w=401wt.eu-S1760672AbYEGBxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760672AbYEGBxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 21:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757994AbYEGBwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 21:52:08 -0400
Received: from smtp-out.google.com ([216.239.33.17]:62939 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759272AbYEGBwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 21:52:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=lZKCs5w9aKmVXZmlIe2dnP9I3QM5LlOpDnW33UzzawKcTaD8tj6CofbFy7MZy0yQf
	/KuB/AeW1fEe++FsycpZQ==
Message-ID: <6599ad830805061851n767ff7a1qc8cb850ec98ad60d@mail.gmail.com>
Date: Tue, 6 May 2008 18:51:58 -0700
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH] Fix cpuset sched_relax_domain_level control file
Cc: "Li Zefan" <lizf@cn.fujitsu.com>, akpm@linux-foundation.org,
       seto.hidetoshi@jp.fujitsu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080506204946.7754302d.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48210101.1070205@google.com>
	 <20080506183841.e1771032.akpm@linux-foundation.org>
	 <482109E5.5050204@cn.fujitsu.com> <20080506204946.7754302d.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2008 at 6:49 PM, Paul Jackson <pj@sgi.com> wrote:
> > Or maybe we can restrict the value from -1 to 5 ?
>
>  That might be a good idea.  My recollection is that this
>  is what we tell users to input ... values between -1 and
>  some small positive integer.  So returning -EINVAL on an
>  input of -2 (for example) should be the least surprising
>  behaviour for users.

That sounds fine to me too - I was just trying to get close to the
original behaviour.

Paul
