Return-Path: <linux-kernel-owner+w=401wt.eu-S1760096AbXKBSuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096AbXKBSuz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 14:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755797AbXKBSus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 14:50:48 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:36164 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757019AbXKBSur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 14:50:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jNoGG2tSfE5JVl9prRf4b6iOX5iZaibeg8XhQCqkXc9Z60IZyHeSFWT0IlWlzZfLOzjKHtC5uF/OtA4nW4ZbrdF1019+UYc/vvybVJnvs/XqhpQZX6tGL8WF5YVTsbTSBuODWuDP+i9RVSoLaPDBZtzV4l2W0I0l7Lj9n5MM/D0=
Message-ID: <1865922a0711021150r351cf210x39deb70888365abf@mail.gmail.com>
Date: Fri, 2 Nov 2007 20:50:46 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: [PATCH] Smackv9: Use a stateful parser for parsing Smack rules
Cc: casey@schaufler-ca.com, akpm@osdl.org, torvalds@osdl.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@ftp.linux.org.uk
In-Reply-To: <Pine.LNX.4.64.0711011826470.24502@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071101155445.GB19231@ubuntu>
	 <Pine.LNX.4.64.0711011826470.24502@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/1/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Nov 1 2007 17:54, Ahmed S. Darwish wrote:
> >+
> >+static inline int isblank(char c)
> >+{
> >+      return (c == ' ' || c == '\t');
> >+}
>
> Use isspace().
>

isspace accepts newlines and carriage-returns too which is not
accepted between elements of a one rule.

> >+      for (i = 0; i < count && data[i]; i ++)
> >...
> >+                      subjectstr[(*label_len) ++] = data[i];
>
> i++ w/o space
>

Notes Taken. Thanks for the review.

Regards,

Darwish
