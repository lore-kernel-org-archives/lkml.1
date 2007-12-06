Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169AbXLFKNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbXLFKNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 05:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbXLFKNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 05:13:43 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:52252 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbXLFKNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 05:13:42 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: Jean Delvare <khali@linux-fr.org>
Cc: Jay Vosburgh <fubar@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: bonding sysfs output
References: <87tznafjeu.fsf@szonett.ki.iif.hu>
	<20071125205150.4e49915f.akpm@linux-foundation.org>
	<87lk8lflzf.fsf@szonett.ki.iif.hu>
	<20071205235905.7e8ac1b1@hyperion.delvare>
Date: Thu, 06 Dec 2007 11:13:28 +0100
In-Reply-To: <20071205235905.7e8ac1b1@hyperion.delvare> (Jean Delvare's
	message of "Wed, 5 Dec 2007 23:59:05 +0100")
Message-ID: <87ve7cxh9z.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare <khali@linux-fr.org> writes:

> On Mon, 26 Nov 2007 09:29:40 +0100, Wagner Ferenc wrote:
>
>> On the policy side: some files are not applicable to some types of
>> bonds, and return a single linefeed in that case.  Except for one
>> single case, which returns 'NA\n'.  The patch changes these cases into
>> emtpy files.
>
> IMHO a better approach would be to not create the files at all when
> they make no sense for a given type of bond.

That would require much more in-depth changes in the sysfs code, I'm
afraid.  But see also the 5th patch in the series, which reponds to
Jay's suggestion.  And as such, goes in the opposite direction.
-- 
Thanks,
Feri.
