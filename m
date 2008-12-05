Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbYLERcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbYLERcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 12:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbYLERcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 12:32:09 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:11110 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbYLERcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 12:32:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=kWU+oTF2vPFSc8BmwUihtaHxCjUwnUC4+LYFh6kNGysbsg64kBi+9+Q1b27NRhjIFs
         dX3xgKdO3zIOOuD7Zz4OFAlZnSjgaSg9RoyTYUTqhltPgOExsihcqFQV8pSmHbEu64li
         ZXTgqbKTb75+JgNxltfi1FIkFsqXXBYmc/q58=
Message-ID: <119aab440812050932h9173a4bm79273b7ea8fe9a3a@mail.gmail.com>
Date: Fri, 5 Dec 2008 12:32:04 -0500
From: "Carlos O'Donell" <carlos@systemhalted.org>
To: "Dave Airlie" <airlied@gmail.com>
Subject: Re: IO space memcpy support for userspace.
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       libc-alpha@sources.redhat.com
In-Reply-To: <21d7e9970812041940h29994c60w3e7bcf20b96efe04@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <21d7e9970812041940h29994c60w3e7bcf20b96efe04@mail.gmail.com>
X-Google-Sender-Auth: cd1df5cae69b2c8f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2008 at 10:40 PM, Dave Airlie <airlied@gmail.com> wrote:
> I'm sure this has come up before and I'm sure I'll either wish I never
> posted this or someone will show me the crisp corpse of the last guy
> who suggested it.

Do you plan to prevent the compiler from issuing the same sorts of
instructions that might appear in an optimized memcpy?

Isn't it dangerous to have memory that doesn't behave like normal
memory, and yet try to treat it like normal memory?

This mismatch of abstractions is a warning that must not be ignored.

IMHO you need a thin library with a new API (adding support for HAL
would be a clever way to check for PCI devices and perhaps even
mappings).

Cheers,
Carlos.
