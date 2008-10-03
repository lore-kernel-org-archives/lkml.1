Return-Path: <linux-kernel-owner+w=401wt.eu-S1753161AbYJCR7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbYJCR7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 13:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbYJCR7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 13:59:13 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:7433 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbYJCR7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 13:59:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=q3aPjvlPEfj9PC2orq8ZESGNY3q8byzE7js3PHz01pZP9516vO6HhaJE01D9ZcEOuu
         Ldz5Gx3iSCwp8/T9fs5PAm7w2/rTKx4Lh+7M5IHtYeT4+eeV/vuZBw48Hu0Jw0/RzPOI
         YaitJ+Enq42pN6nLT+Hv3j+3jjIyWHpytfXM4=
Message-ID: <c62985530810031059v5ed44e04qebaf9453710e76c1@mail.gmail.com>
Date: Fri, 3 Oct 2008 19:59:08 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Alan Jenkins" <aj504@student.cs.york.ac.uk>
Subject: Re: [PATCH -tip] Tracing/fastboot: Only trace non-module initcalls
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <48E659CB.5030902@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48E62089.7050006@gmail.com> <48E659CB.5030902@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/3 Alan Jenkins <aj504@student.cs.york.ac.uk>:
> Sorry to butt in.  I think tracing module initcalls was a deliberate addition by Arjan (a06e1c2b448b317bc141934879cbbbed8319b4d4).
>
> Maybe you use an initrd and that affects the trace?  It would be nice to see the "before" svg as well as the "after", to explain the change.
>
> Thanks
> Alan


Hi Alan,

The script bootgraph.pl in -tip stops the analyzing when it sees
"Freeing unused kernel memory". That's
exactly when the built-in initcalls are finished.
And as a result, the graph produced with dmesg always finishes at this point.

If you try to generate a graph whithout this limitation, you will not
be able to see something interesting because
the script will not find a lot of initcalls with a long enough time
proportion against the total boot time.
Perhaps it can be improved in that way but unfortunately I don't know
any word in Perl....
