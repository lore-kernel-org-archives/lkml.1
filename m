Return-Path: <linux-kernel-owner+w=401wt.eu-S1752173AbXCHBgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbXCHBgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 20:36:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbXCHBgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 20:36:11 -0500
Received: from smtp-out.google.com ([216.239.45.13]:27676 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbXCHBgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 20:36:09 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=vovXne8vRgWa+LCY4kT+6VGIb/k0VD9nvfZrhz/w8oAEKxnqsi1GCVhe3KR3EO+vP
	KfZ1bqFPQSdybXaUmRa6A==
Message-ID: <6599ad830703071735m222e26b7v47a54ca0aaffd902@mail.gmail.com>
Date: Wed, 7 Mar 2007 17:35:58 -0800
From: "Paul Menage" <menage@google.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Cc: "Sam Vilain" <sam@vilain.net>, "Srivatsa Vaddagiri" <vatsa@in.ibm.com>,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       xemul@sw.ru, dev@sw.ru, pj@sgi.com, winget@google.com,
       containers@lists.osdl.org, "Serge E. Hallyn" <serue@us.ibm.com>,
       akpm@linux-foundation.org
In-Reply-To: <m1d53ka5b9.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070301133543.GK15509@in.ibm.com>
	 <20070307205846.GB7010@sergelap.austin.ibm.com>
	 <6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com>
	 <m1odn4bs6n.fsf@ebiederm.dsl.xmission.com>
	 <6599ad830703071518y715ecdb2y33752a6e25b5ecdb@mail.gmail.com>
	 <45EF5A62.8000103@vilain.net>
	 <6599ad830703071642n69bbd801n6114fa6f9e60a168@mail.gmail.com>
	 <45EF5E71.7090101@vilain.net>
	 <6599ad830703071658q60466dd8hd18a1eab9bc17535@mail.gmail.com>
	 <m1d53ka5b9.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Pretty much.  For most of the other cases I think we are safe referring
> to them as resource controls or resource limits.    I know that roughly covers
> what cpusets and beancounters and ckrm currently do.

Plus resource monitoring (which may often be a subset of resource
control/limits).

>
> The real trick is that I believe these groupings are designed to be something
> you can setup on login and then not be able to switch out of.

That's going to to be the case for most resource controllers - is that
the case for namespaces? (e.g. can any task unshare say its mount
namespace?)

Paul
