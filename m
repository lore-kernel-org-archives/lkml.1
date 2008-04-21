Return-Path: <linux-kernel-owner+w=401wt.eu-S1758077AbYDUArJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077AbYDUArJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 20:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYDUAq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 20:46:56 -0400
Received: from rv-out-0708.google.com ([209.85.198.243]:22552 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751503AbYDUAqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 20:46:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=awYggEqrCEoqVjtA3jH1YjggJxjne/6eEZrQTucHC4ji8yqhV4AmlgubjM2fmjG7YQpUf9Ga+o7PMGcIp0/g9UNVtJv6J2xKsO8Woq/R2gbEEWDmV9rPOqo78gaVb5paPtcSQ6cL0dvIeJKmubipLdIdFQB1JM6XrCrVN1WPTIc=
Message-ID: <ba7d8f720804201746x60ff3ee3o415c60de96d897b6@mail.gmail.com>
Date: Sun, 20 Apr 2008 20:46:53 -0400
From: "Dan Upton" <upton.dan.linux@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: migration thread and active_load_balance
In-Reply-To: <87tzhw8b1k.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ba7d8f720804201121h6c024dcrabd301c8b4be7a4@mail.gmail.com>
	 <87tzhw8b1k.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  >
>  > Anyway, like I said, I've spent several days trying to understand this
>  > error by putting in printk()s galore and doing traces through the
>
>  That might be obvious, but are you aware that printks inside
>  the scheduler can lead to deadlocks? printk when the buffer
>  is full calls wake_up and that calls the scheduler. So for
>  debugging the scheduler you need some other way to get
>  the information out.
>
>  -Andi
>

Yes, I've read that printk can cause deadlocks, although I get the
deadlocks without printks as well.  Also, I found a modification on
kerneltrap (http://kerneltrap.org/mailarchive/linux-kernel/2008/1/23/595569)
that seems to a decent job of preventing deadlocks due to printk, at
least in my case (I see in the comments on that thread though that
it's not perfect).

-dan
