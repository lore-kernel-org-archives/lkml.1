Return-Path: <linux-kernel-owner+w=401wt.eu-S933219AbYB0A4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219AbYB0A4P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 19:56:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932637AbYB0Azv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 19:55:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64339 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932275AbYB0Azu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 19:55:50 -0500
Message-ID: <47C4B4B0.4010700@cn.fujitsu.com>
Date: Wed, 27 Feb 2008 08:54:08 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: menage@google.com
CC: akpm@linux-foundation.org, balbir@in.ibm.com, pj@sgi.com,
       Pavel Emelianov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: Re: [PATCH 05/10] CGroup API files: Update cpusets to use cgroup
 structured file API
References: <20080223224725.115590000@menage.corp.google.com> <20080223232617.958345000@menage.corp.google.com>
In-Reply-To: <20080223232617.958345000@menage.corp.google.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

menage@google.com wrote:
> +	case FILE_MEMORY_MIGRATE:
> +		return is_memory_migrate(cs);
> +	case FILE_MEMORY_PRESSURE_ENABLED:
> +		return cpuset_memory_pressure_enabled;
> +	case FILE_MEMORY_PRESSURE:
> +		return fmeter_getrate(&cs->fmeter);
> +		break;

redundant 'break'
