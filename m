Return-Path: <linux-kernel-owner+w=401wt.eu-S1757138AbYE3C5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138AbYE3C5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 22:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753496AbYE3C5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 22:57:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:28589 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbYE3C5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 22:57:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=q0c2I5WIbewal7rtEdCvZZM+pJf00nXaVCqdypeUCM/C1ambUoF79sN5BdRq8Hwsyn1MFpdA+HHqK3tKhiiudKjYUESgG9zxbIi31XZ6ifmi4Qg1k0ZQBbFqEWnlyo26Mwl9AeXBjZulqTEHnpu+/jfeS6JV001B8/b7XwdVqSg=
Message-ID: <b6c5339f0805291956j1d39b728n6482003d4b79141b@mail.gmail.com>
Date: Thu, 29 May 2008 22:56:59 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Johannes Berg" <johannes@sipsolutions.net>, oliver@neukum.org
Subject: Re: 2.6.26-rc3 - appletouch resume "incomplete data package"
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
In-Reply-To: <1211800004.17151.51.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6c5339f0805251324k70a3a56ci9cab5274acc2d01d@mail.gmail.com>
	 <1211800004.17151.51.camel@johannes.berg>
X-Google-Sender-Auth: 300a3df2298684d9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2008 at 7:06 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2008-05-25 at 16:24 -0400, Bob Copeland wrote:
>> This appears to be a regression since 2.6.25.  After resuming, I get:
>>
>>     appletouch: incomplete data package (first byte: 2, length: 4).
>>     appletouch: incomplete data package (first byte: 2, length: 4).
>>     appletouch: incomplete data package (first byte: 2, length: 4).

> I have intermittently seen this problem happen for quite a while, a
> bisect will probably not help you.

Hmm, well the console switch in suspend may be triggering it, but I
didn't have the issue in 2.6.25 and it seems to be easily repeatable
for me in .26 so far.  Doing ctrl-alt-f1 to switch to text mode and
back a dozen times didn't break the mouse, but suspending once did.

I tried a bisect anyway but didn't come up with any smoking gun.  Darn.

-- 
Bob Copeland %% www.bobcopeland.com
