Return-Path: <linux-kernel-owner+w=401wt.eu-S1753999AbYJ1SHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbYJ1SHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 14:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbYJ1SHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 14:07:47 -0400
Received: from exhub016-1.exch016.msoutlookonline.net ([207.5.72.163]:18707
	"EHLO EXHUB016-1.exch016.msoutlookonline.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752532AbYJ1SHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 14:07:47 -0400
Message-ID: <490754F1.1080607@cfl.rr.com>
Date: Tue, 28 Oct 2008 14:07:45 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Thomas Guyot-Sionnest <dermoth@aei.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: CFQ Idle class slowing down everything?
References: <gcm0sv$ra4$1@ger.gmane.org> <20081014121859.4778abcf.akpm@linux-foundation.org> <490226C9.4000406@aei.ca>
In-Reply-To: <490226C9.4000406@aei.ca>
Content-Type: text/plain; charset="windows-1251"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Guyot-Sionnest wrote:
> On 14/10/08 03:18 PM, Andrew Morton wrote:
>>> When "idle", the slave do mostly random writes: about 15 rtps and 200
>>> wtps. For testing I ended up running dd to read files from disk to
>>> /dev/null while avoiding the system cache (had 42GB of data to read

Just thought I would point out that dd is, in fact, dirtying the buffer 
cache since you don't pass flag=direct.

