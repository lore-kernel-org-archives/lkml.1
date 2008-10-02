Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbYJBJNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbYJBJNE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 05:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbYJBJMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 05:12:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58619 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbYJBJMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 05:12:54 -0400
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch x86/core] x86: allow number of additional hotplug CPUs to be set at compile time
From: Andi Kleen <andi@firstfloor.org>
References: <20081001191945.4182d0be@redhat.com>
Date: Thu, 02 Oct 2008 11:12:51 +0200
In-Reply-To: <20081001191945.4182d0be@redhat.com> (Chuck Ebbert's message of "Wed, 1 Oct 2008 19:19:45 -0400")
Message-ID: <87bpy3pdgs.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert <cebbert@redhat.com> writes:

> The default number of additional CPU IDs for hotplugging is determined
> by asking ACPI or mptables how many "disabled" CPUs there are in the
> system, but many systems get this wrong so that e.g. a uniprocessor
> machine gets an extra CPU allocated and never switches to single CPU
> mode.

You can set this with additional_cpus=... at boot time.
I don't think each runtime option needs a CONFIG option too.

-Andi
