Return-Path: <linux-kernel-owner+w=401wt.eu-S1760168AbZBETQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760168AbZBETQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbZBETQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:16:29 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:6659 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbZBETQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:16:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=t2rrOKJp09+A8UyONWIw+IL96q/fPGH4D5hP8dxYYY4GMsIDA8IqkV4vgS3GRKIyFN
         EzSlDJhkXhS5kdGe4AlwVMvpfEJDg/+P8O1ht6qjmTa+oZCW+HbL7QGZnFSVZA50WTIJ
         yHa9+j4FtPVqtOF61/7aJqpx1ON9rXwdo//1A=
MIME-Version: 1.0
In-Reply-To: <1233861023.22037.0.camel@brick>
References: <1233860727-16884-1-git-send-email-ericvh@gmail.com>
	 <1233861023.22037.0.camel@brick>
Date: Thu, 5 Feb 2009 13:16:27 -0600
Message-ID: <a4e6962a0902051116r1921e976idd8f820568d40bd5@mail.gmail.com>
Subject: Re: [PATCH] 9p: fix endian issues [attempt 2]
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 5, 2009 at 1:10 PM, Harvey Harrison
<harvey.harrison@gmail.com> wrote:
> On Thu, 2009-02-05 at 13:05 -0600, ericvh@gmail.com wrote:
>> From: Eric Van Hensbergen <ericvh@gmail.com>
>>
>> When the changes were done to the protocol last release, some endian
>> bugs crept in.  This patch fixes those endian problems and has been
>> verified to run on 32/64 bit and x86/ppc architectures.
>>
>> This version of the patch incorporates the correct annotations
>> for endian variables.
>>
>> Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
>
> Looks better to me.
>

Thanks for your help.  Unfortunately, I was trigger happy with the
commit and added whitespace, so everyone gets to see this patch one
more time (sorry).

           -eric
