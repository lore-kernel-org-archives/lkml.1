Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088Ab0BLVQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 16:16:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58707 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab0BLVQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 16:16:10 -0500
X-Authority-Analysis: v=1.0 c=1 a=uTOmaDeAZlAA:10 a=7U3hwN5JcxgA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=1WlqOSNv0P0-JdMuWbgA:9 a=LhlhnYxUvuJ4E2E7H_35WRNA2EkA:4 a=HEdnscJc8mAA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [kernel.org users] XZ Migration discussion
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Junio C Hamano <gitster@pobox.com>
Cc: Jean Delvare <khali@linux-fr.org>, "J.H." <warthog9@kernel.org>,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>, users@kernel.org,
       lasse.collin@tukaani.org, linux-kernel <linux-kernel@vger.kernel.org>,
       mirrors@kernel.org
In-Reply-To: <7vocjury5q.fsf@alter.siamese.dyndns.org>
References: <4B744E13.8040004@kernel.org>
	 <20100212150137.648dca7c@hyperion.delvare>
	 <1265988318.24271.30.camel@gandalf.stny.rr.com>
	 <20100212171149.5c9f78d2@hyperion.delvare>
	 <1265992239.24271.38.camel@gandalf.stny.rr.com>
	 <7vocjury5q.fsf@alter.siamese.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 12 Feb 2010 16:16:04 -0500
Message-ID: <1266009364.24271.86.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-12 at 12:34 -0800, Junio C Hamano wrote:
> Steven Rostedt <rostedt@goodmis.org> writes:
> 
> > On Fri, 2010-02-12 at 17:11 +0100, Jean Delvare wrote:
> >
> >> What would you consider a reasonable turnaround time? 3 month? 6 month?
> >> More?
> >> 
> >> We could make a decision now, you update ketchup immediately, and the
> >> actual change happens at the specified date in the future.
> >> 
> >
> > Usually users don't update ketchup until it breaks ;)
> 
> Then the archive location can change immediately after you issue an update
> ;-)
> 
> Would it be an option for a newer version of ketchup to have a fallback
> codepath to read a machine-readable description of how the archive is
> structured from a known location?  E.g. instead of appending a hard-coded
> string '/people/akpm/patches/2.6/' when computing latest_mm(), the script
> would read that "relative path to mm" from such a description file.  The
> logic of doing 'url = "%s/v%s/%s" % (kernel_url, t, f)' in install_nearest
> would similarly be customizable, without too much hassle, I think.

Are you suggesting that the path be stored at a known location on
kernel.org? Such that it can be read and the tools like ketchup can find
where a particular version resides?

-- Steve


