Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbZC2MDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbZC2MDP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 08:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753809AbZC2MC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 08:02:58 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:9479 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbZC2MC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 08:02:57 -0400
X-RZG-AUTH: :LWIQcGC8af5qXkYNYt77sURZEFmV4M3TAgvB+Qeh4tE+44JfzNbYav6UBdLY
X-RZG-CLASS-ID: mo05
Message-ID: <49CF636A.3030400@ursus.ath.cx>
Date: Sun, 29 Mar 2009 14:02:50 +0200
From: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
CC: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: Zero length files - an alternative approach?
References: <87bprka9sg.fsf@newton.gmurray.org.uk> <yw1xab744lqi.fsf@thrashbarg.mansr.com>
In-Reply-To: <yw1xab744lqi.fsf@thrashbarg.mansr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 29.03.2009 13:22 Måns Rullgård wrote:
> Consider this scenario:
>
> 1. Create/write/close newfile
> 2. Rename newfile to oldfile
> 3. Open/read oldfile.  This must return the new contents.
> 4. System crash and reboot before delayed allocation/flush complete
> 5. Open/read oldfile.  Old contents now returned.
>
> This rollback isn't obviously, to me at least, without problems of its
> own.
>
>   
Having the old data in 5) is far better than having no data in 5).
