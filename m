Return-Path: <linux-kernel-owner+w=401wt.eu-S1755008AbXFYRhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbXFYRhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 13:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbXFYRgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 13:36:53 -0400
Received: from smtp-out.google.com ([216.239.33.17]:51184 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbXFYRgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 13:36:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=kKa5rq9UvsGuFGKeI62Q97VMQZUjy64UOO9611BR5hLNiKzWTWobGmhkvSPlDPNd1
	TO4lzlE7dFbtJapvH4usg==
Message-ID: <6599ad830706251036i43fd6069x9b4191cb672b4f21@mail.gmail.com>
Date: Mon, 25 Jun 2007 10:36:37 -0700
From: "Paul Menage" <menage@google.com>
To: "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>
Subject: Re: [RFC] mm-controller
Cc: "Peter Zijlstra" <peterz@infradead.org>, balbir@linux.vnet.ibm.com,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Linux Containers" <containers@lists.osdl.org>,
       linux-mm <linux-mm@kvack.org>, "Balbir Singh" <balbir@in.ibm.com>,
       "Pavel Emelianov" <xemul@sw.ru>, "Kirill Korotaev" <dev@sw.ru>,
       devel@openvz.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Herbert Poetzl" <herbert@13thfloor.at>,
       "Roy Huang" <royhuang9@gmail.com>, "Aubrey Li" <aubreylee@gmail.com>
In-Reply-To: <6599ad830706251035t37f916dcr5e35e40e3470482c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1182418364.21117.134.camel@twins>
	 <467A5B1F.5080204@linux.vnet.ibm.com>
	 <1182433855.21117.160.camel@twins>
	 <467BFA47.4050802@linux.vnet.ibm.com>
	 <6599ad830706251035t37f916dcr5e35e40e3470482c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/25/07, Paul Menage <menage@google.com> wrote:
> On 6/22/07, Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> >
> > Merging both limits will eliminate the issue, however we would need
> > individual limits for pagecache and RSS for better control.  There are
> > use cases for pagecache_limit alone without RSS_limit like the case of
> > database application using direct IO, backup applications and
> > streaming applications that does not make good use of pagecache.
> >
>
> If streaming applications would otherwise litter the pagecache with
> unwanted data, then limiting their total memory footprint (with a
> single limit) and forcing them to drop old data sooner sounds like a
> great idea.

Actually, reading what you wrote more carefully, that's sort of what
you were already saying. But it's not clear why you wouldn't also want
to limit the anon pages for a job, if you're already concerned that
it's not playing nicely with the rest of the system.

Paul
