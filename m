Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710Ab0BLUet (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 15:34:49 -0500
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:52336 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756973Ab0BLUes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 15:34:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:cc:subject
	:references:from:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=Nn+EIme9yUO3D6699gLcIzIi3oQa70tj
	9IDN4qXqrcrcxNmgDfpm5uuPbeNcO1JYXja7gOCe8mmg02r+ceg8htGdZ8eDTW1B
	eobzfw2koBUlaVoHVFJyGaKBpLxe9Ugk2XIMzw0l4x99eqPLJE20JTv6260zKxbj
	CfuQj62ppIo=
To: rostedt@goodmis.org
Cc: Jean Delvare <khali@linux-fr.org>, "J.H." <warthog9@kernel.org>,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>, users@kernel.org,
       lasse.collin@tukaani.org, linux-kernel <linux-kernel@vger.kernel.org>,
       mirrors@kernel.org
Subject: Re: [kernel.org users] XZ Migration discussion
References: <4B744E13.8040004@kernel.org>
 <20100212150137.648dca7c@hyperion.delvare>
 <1265988318.24271.30.camel@gandalf.stny.rr.com>
 <20100212171149.5c9f78d2@hyperion.delvare>
 <1265992239.24271.38.camel@gandalf.stny.rr.com>
From: Junio C Hamano <gitster@pobox.com>
Date: Fri, 12 Feb 2010 12:34:25 -0800
In-Reply-To: <1265992239.24271.38.camel@gandalf.stny.rr.com> (Steven
 Rostedt's message of "Fri\, 12 Feb 2010 11\:30\:39 -0500")
Message-ID: <7vocjury5q.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 0941859E-1816-11DF-852C-6AF7ED7EF46B-77302942!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> On Fri, 2010-02-12 at 17:11 +0100, Jean Delvare wrote:
>
>> What would you consider a reasonable turnaround time? 3 month? 6 month?
>> More?
>> 
>> We could make a decision now, you update ketchup immediately, and the
>> actual change happens at the specified date in the future.
>> 
>
> Usually users don't update ketchup until it breaks ;)

Then the archive location can change immediately after you issue an update
;-)

Would it be an option for a newer version of ketchup to have a fallback
codepath to read a machine-readable description of how the archive is
structured from a known location?  E.g. instead of appending a hard-coded
string '/people/akpm/patches/2.6/' when computing latest_mm(), the script
would read that "relative path to mm" from such a description file.  The
logic of doing 'url = "%s/v%s/%s" % (kernel_url, t, f)' in install_nearest
would similarly be customizable, without too much hassle, I think.
