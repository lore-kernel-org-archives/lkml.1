Return-Path: <linux-kernel-owner+w=401wt.eu-S1757581AbYAHQwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbYAHQwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 11:52:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbYAHQvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 11:51:52 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:54464 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbYAHQvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:51:51 -0500
Subject: Re: [PATCH] Deprecate checkpatch.pl --file
From: Daniel Walker <dwalker@mvista.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, apw@shadowen.org, akpm@linux-foundation.org
In-Reply-To: <20080108161403.GA11632@basil.nowhere.org>
References: <20080108161403.GA11632@basil.nowhere.org>
Content-Type: text/plain
Date: Tue, 08 Jan 2008 08:50:33 -0800
Message-Id: <1199811033.1756.29.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-08 at 17:14 +0100, Andi Kleen wrote:


> +if ($file) {
> +	print <<EOL
> +WARNING: Using --file mode. Please do not send patches to linux-kernel
> +that change whole existing files if you did not significantly change most
> +of the the file for other reasons anyways or just wrote the file newly
> +from scratch. Pure code style patches have a significant cost in a
> +quickly changing code base like Linux because they cause rejects
> +with other changes.
> +If you're sure you want to use whole file mode please use --file-force
> +EOL
> +;
> +	exit(1);

Can't say I like this too much .. It sounds like your telling people to
stop sending cleanup patches, which doesn't make much sense .. We want a
clean kernel .. Or at least I do ..

Linus and Andrew could slow acceptable of these patches, but I don't
think discouraging people from cleaning up code and submitting a patch
for that is the right thing to do..

(Btw, I changed to akpm@linux-foundation.org and not @osdl.org .. )

Daniel


